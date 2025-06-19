class Api::V1::ReportsController < ApiApplicationController
  before_action :set_vehicle
  def trips
    service = GpsService.new
    service.login
    pp params
    response = Rails.cache.fetch("trips_#{params.permit!.to_h}", expires_in: 5.day) do
      service.reports_trips(
        @vehicle.external_id, params[:from].to_s, params[:to].to_s
      )
    end
    if response["statusCode"] != 200
      render json: { mssg: response["message"] }, status: :bad_request
      return
    end

    data = response["data"] || []
    render json: data.as_json
  end

  private
  def set_vehicle
    @vehicle = Vehicle.where(id: params[:vehicle_id]).first
    unless @vehicle
      render json: { mssg: "not found" }, status: :not_found
    end
  end
end

# frozen_string_literal: true

class Api::V1::VehiclesController < ApiApplicationController
  before_action :set_vehicle, only: [ :show, :recommended]

  def index
    render json: current_user.vehicles.as_json
  end

  def show
    render json: @vehicle.as_json
  end

  def recommended
    render json: @vehicle.recommended
  end

  private
  def set_vehicle
    @vehicle = Vehicle.where(id: params[:id]).first

    render json: { mssg: "Vehicle not found" }, status: :not_found unless @vehicle
  end
end

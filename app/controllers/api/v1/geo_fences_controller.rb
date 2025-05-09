class Api::V1::GeoFencesController < ApiApplicationController
  before_action :set_geo_fence, only: [ :show, :update, :destroy ]

  # GET /geo_fences
  def index
    @geo_fences = GeoFence.enabled

    render json: @geo_fences.as_json
  end

  def show
    render json: @geo_fence.as_json
  end

  def create
    @geo_fence = GeoFence.new
    @geo_fence.assign_attributes(geo_fence_params)
    @geo_fence.user = current_user

    if @geo_fence.valid?
      @geo_fence.save
      render json: @geo_fence.as_json, status: :created
    else
      render json: { mssg: "Error creating GeoFence: " + @geo_fence.errors.full_messages.join(",") }, status: :unprocessable_entity
    end
  end

  def update
    if @geo_fence.update(geo_fence_params)
      render json: @geo_fence.as_json
    else
      render json: { mssg: "Error updating GeoFence" }, status: :unprocessable_entity
    end
  end

  def destroy
    if @geo_fence.update(is_enabled: !@geo_fence.is_enabled)
      render json: { mssg: "GeoFence deleted" }, status: :ok
    else
      render json: { mssg: "Error deleting GeoFence" }, status: :unprocessable_entity
    end
  end

  private
  def set_geo_fence
    @geo_fence = GeoFence.where(id: params[:id]).first

    render json: { mssg: "GeoFence not found" }, status: :not_found unless @geo_fence
  end

  def geo_fence_params
    params.require(:geo_fence).permit([
      :name, :description, :radius, :is_enabled, :type_cd, vehicle_ids: [],
      area_geojson: {},
      centroid_geojson: {}
    ])
  end
end

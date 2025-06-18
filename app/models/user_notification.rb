class UserNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :translate, type: String
  field :server_time, type: DateTime
  field :lat, type: Float
  field :lon, type: Float
  field :speed, type: Float
  field :course, type: Float
  field :external_device_id, type: String
  field :external_id, type: String
  field :is_enabled, type: Mongoid::Boolean, default: true
  field :label_direction, type: String, default: true

  belongs_to :user, inverse_of: :user_notifications, index: true
  belongs_to :vehicle, inverse_of: :user_notifications, index: true
  belongs_to :geo_fence, inverse_of: :user_notifications, optional: true, index: true

  index({ external_id: 1 }, { unique: true })
  index({ is_enabled: 1, server_time: -1}, { background: true })

  default_scope -> { where(is_enabled: true).order_by(server_time: -1) }

  def destroy(options = nil)
    self.is_enabled = false
    self.save
  end

  def build_from_server(info)
    self.external_id = info["ID"]
    self.type = info["Type"]
    self.translate = info["Translate"]
    self.server_time = Time.new(info["ServerTime"], in: "UTC")
    self.lat = info["Latitude"]
    self.lon = info["Longitude"]
    self.speed = info["Speed"]
    self.course = info["Course"]
    self.external_device_id = info["DeviceID"]
    self.vehicle = Vehicle.where(external_id: self.external_device_id).first
    self.user = self.vehicle.user if self.vehicle
    self.geo_fence = GeoFence.where(id: info["GeoFence"]).first if info["GeoFence"].present?
    self.save
  end

  def search_label_direction
    suggestion = SuggestionService.new
    reverse_response = suggestion.reverse(lat:, lon:)
    self.label_direction = [
      reverse_response.dig("properties", "label"),
      reverse_response.dig("properties", "admin_area_3"),
      reverse_response.dig("properties", "admin_area_2"),
      reverse_response.dig("properties", "admin_area_1")
    ].compact_blank.join(", ")
    save
  end
end

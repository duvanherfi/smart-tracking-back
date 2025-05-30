class Vehicle
  include Mongoid::Document
  include Mongoid::Timestamps

  field :plates, type: String
  field :model, type: String
  field :category, type: String
  field :lat, type: String
  field :lon, type: String
  field :course, type: String
  field :speed_limit, type: Float
  field :external_id, type: String
  field :last_update_from_server, type: DateTime
  field :last_update_from_gps, type: DateTime
  field :battery_level, type: String
  field :distance, type: String
  field :total_distance, type: String
  field :hours, type: Float
  field :ip, type: String
  field :rssi, type: String
  field :average_speed, type: String
  field :max_speed, type: String
  field :label_direction, type: String
  field :raw_response, type: Hash
  field :motion, type: Mongoid::Boolean, default: true
  field :ignition, type: Mongoid::Boolean, default: true
  field :charge, type: Mongoid::Boolean, default: true
  field :blocked, type: Mongoid::Boolean, default: true
  field :is_enabled, type: Mongoid::Boolean, default: true

  belongs_to :user, index: true
  has_many :positions
  has_and_belongs_to_many :geo_fences, index: true


  def update_from_service
    service = GpsService.new
    service.login
    suggestion = SuggestionService.new
    response_devices = service.devices
    response_summary = service.summary(external_id)&.dig("data")
    reverse_response = suggestion.reverse(lat:, lon:)
    vehicle_response = response_devices["data"].select { |vehicle| vehicle["ID"].to_s == self.external_id }.first
    attributes = vehicle_response["Attributes"]
    attrs = {
      raw_response: vehicle_response,
      plates: vehicle_response["Name"],
      model: vehicle_response["Model"],
      category: vehicle_response["Category"],
      lat: vehicle_response["Latitude"],
      lon: vehicle_response["Longitude"],
      course: vehicle_response["Course"],
      speed_limit: vehicle_response["SpeedLimit"],
      last_update_from_server: Time.now,
      last_update_from_gps: Time.new(vehicle_response["Lastupdate"], in: "UTC"),
      battery_level: attributes["batteryLevel"],
      distance: attributes["distance"],
      total_distance: attributes["totalDistance"],
      ip: attributes["ip"],
      motion: attributes["motion"],
      hours: attributes["hours"],
      ignition: attributes["ignition"],
      charge: attributes["charge"],
      rssi: attributes["rssi"],
      blocked: attributes["blocked"],
      average_speed: response_summary["averageSpeed"],
      max_speed: response_summary["maxSpeed"],
      label_direction: [
        reverse_response.dig("properties", "label"),
        reverse_response.dig("properties", "admin_area_3"),
        reverse_response.dig("properties", "admin_area_2"),
        reverse_response.dig("properties", "admin_area_1")
      ].compact.join(", ")
    }
    self.update!(attrs)
  end

  def recommended
    resolutions = [ 7, 6 ]
    h3_ids = self.positions.where(:created_at.gte => Time.now.beginning_of_year).limit(10000).map do |info|
      H3.from_geo_coordinates([ info[:lat].to_f, info[:lon].to_f ], resolutions.sample)
    end
    uniqs = h3_ids.uniq
    coordinates = H3.h3_set_to_linked_geo(uniqs)
    JSON.parse(H3.coordinates_to_geo_json(coordinates))
  end

  def get_locations
    service = GpsService.new
    service.login
    data = service.get_positions(external_id)["data"]["coordinates"]
    v = Vehicle.last
    data.each do |info|
      Position.where(
        lat: info["latitude"].to_f,
        lon: info["longitude"].to_f,
        course: info["course"].to_i,
        speed: info["speed"].to_i,
        time: info["time"],
        vehicle: v
      ).first_or_create
    end
  end
end

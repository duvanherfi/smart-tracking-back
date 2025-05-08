class GeoFence
  include Mongoid::Document
  include Mongoid::Timestamps

  field :area_geojson, type: Hash, default: {}
  field :centroid_geojson, type: Hash
  field :name, type: String
  field :description, type: String
  field :label_direction, type: String
  field :lat, type: Float
  field :lon, type: Float
  field :radius, type: Float
  field :is_enabled, type: Mongoid::Boolean, default: true

  belongs_to :user, required: true
  has_and_belongs_to_many :vehicles, index: true

  before_save :fix_geojson
  before_save :generate_centroid_geojson
  before_save :set_circle_geojson
  before_save :search_label_direction

  validates :name, presence: true

  def fix_geojson
    return if area_geojson.blank?
    return unless area_geojson.first.is_a?(Hash)

    coordinates = area_geojson["coordinates"].first

    coordinates = coordinates["[]"] if coordinates.is_a?(Hash)
    area_geojson["type"] = "Polygon"
    area_geojson["coordinates"] = [ coordinates ]
  end

  def generate_centroid_geojson
    return if centroid_geojson.present?

    coordinates = area_geojson["coordinates"] || area_geojson[:coordinates]
    return if coordinates.nil?

    coordinates = coordinates.flatten.each_slice(2).to_a
    self.lat, self.lon = self.class.polygon_centroid coordinates
    return if self.lat.nil? || self.lon.nil?
    geojson = {
      type: "Point",
      coordinates: [ self.lon, self.lat ]
    }
    self.centroid_geojson = geojson
  end

  def set_circle_geojson
    return if centroid_geojson.blank? || area_geojson.present? || radius.nil?

    circle = Turf.circle(centroid_geojson, radius, steps: 64)
    self.area_geojson = circle[:geometry]
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
  end

  def self.polygon_centroid(coordinates)
    return nil if coordinates.count.zero?

    x_coordinate = 0.0
    y_coordinate = 0.0
    z_coordinate = 0.0
    coordinates.each do |point|
      lat = point[1].to_f * Math::PI / 180
      lon = point[0].to_f * Math::PI / 180

      x_coordinate += Math.cos(lat) * Math.cos(lon)
      y_coordinate += Math.cos(lat) * Math.sin(lon)
      z_coordinate += Math.sin(lat)
    end

    x_coordinate /= coordinates.count
    y_coordinate /= coordinates.count
    z_coordinate /= coordinates.count

    lon = Math.atan2(y_coordinate, x_coordinate)
    hyp = Math.sqrt(x_coordinate * x_coordinate + y_coordinate * y_coordinate)
    lat = Math.atan2(z_coordinate, hyp)

    centroid_lat = (lat * 180 / Math::PI)
    centroid_lon = (lon * 180 / Math::PI)

    [ centroid_lat, centroid_lon ]
  end
end

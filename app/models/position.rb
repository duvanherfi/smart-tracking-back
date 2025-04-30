class Position
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :lat, type: String
  field :lon, type: String
  field :course, type: Integer
  field :speed, type: Integer
  field :time, type: DateTime

  field :is_enabled, type: Mongoid::Boolean, default: true

  belongs_to :vehicle, index: true

  index({ vehicle_id: 1, time: -1}, { background: true })
end

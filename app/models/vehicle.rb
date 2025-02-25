class Vehicle
  include Mongoid::Document
  include Mongoid::Timestamps

  field :external_id, type: String
  field :is_enabled, type: Mongoid::Boolean, default: true

  belongs_to :user
end

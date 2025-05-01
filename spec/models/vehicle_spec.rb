require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  it "is valid with valid attributes" do
    attributes = create(:vehicle).attributes.as_json(except: [ "_id" ])
    vehicle = Vehicle.new(attributes)
    expect(vehicle).to be_valid
    expect(vehicle.save!).to be(true)
    vehicle.update_from_service
    expect(vehicle.lat).not_to be_nil
    expect(vehicle.lon).not_to be_nil
    expect(vehicle.persisted?).to be(true)
  end

  it "Get locations" do
    vehicle = create(:vehicle)
    vehicle.get_locations

    expect(vehicle.positions.count).to be > 0
  end

  it "Get recommended" do
    vehicle = create(:vehicle)
    vehicle.get_locations
    recommended = vehicle.recommended

    expect(recommended).not_to be_nil
  end
end

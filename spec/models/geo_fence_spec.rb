require 'rails_helper'

RSpec.describe GeoFence, type: :model do
  it "is valid with valid attributes" do
    attributes = create(:geo_fence).attributes.as_json(except: [ "_id" ])
    geo_fence = GeoFence.new(attributes)
    expect(geo_fence).to be_valid
    expect(geo_fence.save!).to be(true)
    geo_fence.set_centroid_geojson
    geo_fence.set_label_direction
    expect(geo_fence.centroid_geojson).not_to be_nil
    expect(geo_fence.lat).not_to be_nil
    expect(geo_fence.lon).not_to be_nil
    expect(geo_fence.persisted?).to be(true)
  end

  it "is not valid without a name" do
    geo_fence = GeoFence.new
    expect(geo_fence).to_not be_valid
    expect(geo_fence.save).to be(false)
    expect(geo_fence.persisted?).to be(false)
  end
end

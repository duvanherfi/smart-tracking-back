require 'rails_helper'

RSpec.describe Api::V1::VehiclesController, type: :controller do
  describe "GET #index" do
    it "returns http success with vehicle in array" do
      vehicle = create(:vehicle)
      request.headers["Authorization"] = "Bearer #{vehicle.user.sessions.create.token}"
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to be_a(Array)
      expect(JSON.parse(response.body).last["_id"]).to eq(vehicle.id.to_s)
    end

    it "returns http success with out vehicles in array" do
      user = create(:user)
      request.headers["Authorization"] = "Bearer #{user.sessions.create.token}"
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to be_a(Array)
      expect(JSON.parse(response.body).blank?).to be(true)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      vehicle = create(:vehicle)
      request.headers["Authorization"] = "Bearer #{vehicle.user.sessions.create.token}"
      get :show, params: { id: vehicle.id.to_s }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["_id"]).to eq(vehicle.id.to_s)
    end

    it "returns http not found" do
      user = create(:user)
      request.headers["Authorization"] = "Bearer #{user.sessions.create.token}"
      get :show, params: { id: "1234567890" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #recommended" do
    it "return geojson" do
      vehicle = create(:vehicle)
      vehicle.get_locations
      request.headers["Authorization"] = "Bearer #{vehicle.user.sessions.create.token}"
      get :recommended, params: { id: vehicle.id }
      expect(JSON.parse(response.body)["coordinates"]).to be_a(Array)
      expect(JSON.parse(response.body)["coordinates"][0]).to be_a(Array)
      expect(JSON.parse(response.body)["type"]).to be_a(String)
    end
  end
end

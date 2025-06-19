require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
  let(:user) { create(:user_with_sessions) }
  let(:vehicle) { create(:vehicle, user: user) }

  before(:each) do
    Redis::Value.new("GPS_TOKEN").value = "token"
  end

  describe "GET #trips" do
    it "renders a successful response" do
      request.headers["Authorization"] = "Bearer #{user.sessions.last.token}"
      get :trips, params: { vehicle_id: vehicle.id, from: 1.day.ago, to: Time.current }
      expect(response).to be_successful
      expect(JSON.parse(response.body).any?).to be true
    end
    context "500 response" do
      it "renders a no successful response" do
        request.headers["Authorization"] = "Bearer #{user.sessions.last.token}"
        allow_any_instance_of(GpsService).to receive(:reports_trips).and_return({ "statusCode" => 500, "message" => "Internal Server Error" })
        get :trips, params: { vehicle_id: vehicle.id, from: 1.day.ago, to: Time.current }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body).any?).to be true
      end
    end

    it "renders a no successful response for vehicle" do
      request.headers["Authorization"] = "Bearer #{user.sessions.last.token}"
      get :trips, params: { vehicle_id: "asd", from: 1.day.ago, to: Time.current }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body).any?).to be true
    end
  end
end

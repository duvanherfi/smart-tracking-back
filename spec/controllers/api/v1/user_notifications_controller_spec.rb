require 'rails_helper'

RSpec.describe Api::V1::UserNotificationsController, type: :controller do
  let(:user) { create(:user_with_sessions) }
  let(:vehicle) { create(:vehicle, user: user) }

  let(:valid_attributes) {
    {
      type: 'name',
      is_enabled: true,
      user: user,
      vehicle: vehicle
    }
  }

  describe "GET #index" do
    it "renders a successful response" do
      request.headers["Authorization"] = "Bearer #{user.sessions.last.token}"
      UserNotification.create! valid_attributes
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).any?).to be true
    end
  end
end

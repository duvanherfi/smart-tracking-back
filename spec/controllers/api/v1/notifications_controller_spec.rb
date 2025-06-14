require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do
  let(:user) { create(:user_with_sessions) }

  let(:valid_attributes) {
    {
      name: 'name',
      is_enabled: true,
      user: user
    }
  }

  let(:invalid_attributes) {
    {
      name: '',
      is_enabled: true
    }
  }

  describe "GET #index" do
    it "renders a successful response" do
      request.headers["Authorization"] = "Bearer #{user.sessions.last.token}"
      Notification.create! valid_attributes
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body).any?).to be true
    end
  end

  describe "GET #show" do
    it "renders a successful response" do
      request.headers["Authorization"] = "Bearer #{user.sessions.last.token}"
      notification = Notification.create! valid_attributes
      get :show, params: { id: notification.to_param }
      expect(response).to be_successful
    end
  end

  describe "PATCH #toggle_enabled" do
    context "with valid parameters" do
      it "toggle enabled notification" do
        request.headers["Authorization"] = "Bearer #{user.sessions.last.token}"
        notification = Notification.create! valid_attributes
        patch :toggle_enabled, params: { id: notification.id }
        notification.reload
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["is_enabled"]).to be_falsey
      end
    end
  end
end

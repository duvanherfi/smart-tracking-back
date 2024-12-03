require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET #show" do
    it "returns http success" do
      user = create(:user)
      request.headers["Authorization"] = "Bearer #{user.sessions.create.token}"
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["_id"]).to eq(user.id.to_s)
    end

    it "returns http unauthorized" do
      user = create(:user)
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns http not found" do
      user = create(:user)
      request.headers["Authorization"] = "Bearer #{user.sessions.create.token}"
      get :show, params: { id: "1234567890" }
      expect(response).to have_http_status(:not_found)
    end

    it "can update user" do
      user = create(:user)
      request.headers["Authorization"] = "Bearer #{user.sessions.create.token}"
      put :update, params: { id: user.id, user: { name: "New Name" } }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["name"]).to eq("New Name")
    end

    it "can't update user" do
      user = create(:user)
      request.headers["Authorization"] = "Bearer #{user.sessions.create.token}"
      put :update, params: { id: user.id, user: { email: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "can't update user without token" do
      user = create(:user)
      put :update, params: { id: user.id, user: { email: nil } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe "/login" do
    it "should return 401" do
      post :login, params: { email: "example@gmail.com", password: "password" }
      expect(response.status).to eq(422)
    end

    it "should login" do
      user = create(:user, password: "password")

      post :login, params: { phone: user.phone, password: "password", session: { push_token: "Hola" } }
      expect(response.status).to eq(201)
    end

    it "should logout" do
      user = create(:user, password: "password")
      s = user.sessions.create
      request.headers["Authorization"] = "Bearer #{s.token}"
      post :logout
      expect(response.status).to eq(200)
    end
  end
  describe "/update" do
    it "should update" do
      user = create(:user, password: "password")
      post :login, params: { phone: user.phone, password: "password", session: { push_token: "Hola" } }
      body = JSON.parse(response.body, symbolize_names: true)[:user]
      request.headers["Authorization"] = "Bearer #{body[:token]}"

      put :update, params: { id: body[:session_id], session: { push_token: "Hola2" } }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:user][:push_token]).to eq("Hola2")
    end
  end
end

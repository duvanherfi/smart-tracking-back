require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe "/login" do
    it "should return 401" do
      post :login, params: { email: "example@gmail.com", password: "password" }
      expect(response.status).to eq(401)
    end

    it "should login" do
      user = create(:user, password: "password")

      post :login, params: { phone: user.phone, password: "password" }
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
end

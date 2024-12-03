require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    it "/show" do
      user = create(:user)
      request.headers["Authorization"] = "Bearer #{user.sessions.create.token}"
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    it "/new" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end

    it "/edit" do
      user = create(:user)
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end

    it "can /create" do
      user = build(:user)
      post :create, params: { user: user.attributes.merge(password: "password", password_confirmation: "password") }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(user_path(User.last))
    end

    it "cannot /create" do
      user = build(:user)
      post :create, params: { user: user.attributes }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:new)
    end

    it "can /update" do
      user = create(:user)
      put :update, params: { id: user.id, user: { name: "New Name" } }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(user_path(user))
    end

    it "cannot /update" do
      user = create(:user)
      put :update, params: { id: user.id, user: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(:edit)
    end

    it "can /destroy" do
      user = create(:user)
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(user_path(user))
    end

    it "can see /index" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end
end

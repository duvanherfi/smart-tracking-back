# frozen_string_literal: true

class Api::V1::UsersController < ApiApplicationController
  before_action :set_user, only: [ :show, :update ]

  def show
    render json: session_json
  end

  def update
    if @user.update(user_params)
      render json: session_json
    else
      render json: { mssg: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @user = User.where(id: params[:id]).first
    render json: { mssg: "User not found" }, status: :not_found unless @user
  end

  def user_params
    params.fetch(:user, {}).permit(:name, :email, :phone, :password, :password_confirmation)
  end
end

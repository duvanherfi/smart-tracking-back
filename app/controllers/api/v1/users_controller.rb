# frozen_string_literal: true

class Api::V1::UsersController < ApiApplicationController
  before_action :set_user, only: [ :show, :update ]
  skip_before_action :authenticated, only: [ :recovery_password ]

  def show
    render json: session_json
  end

  def update
    if @user.update(user_params)
      render json: session_json(user: @user)
    else
      render json: { mssg: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def recovery_password
    @user = User.where(phone: params[:phone]).first
    @user.send_email_recovery if @user
    render json: { mssg: "Tu contraseña de recuperación ha sido enviada a tu correo electrónico." }, status: :ok
  end

  private
  def set_user
    @user = User.where(id: params[:id]).first
    render json: { mssg: "User not found" }, status: :not_found unless @user
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
  end
end

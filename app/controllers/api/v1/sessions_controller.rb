# frozen_string_literal: true

class Api::V1::SessionsController < ApiApplicationController
  skip_before_action :authenticated, only: [ :login ]

  def login
    user = User.where(phone: params[:phone]).first
    if user&.authenticate(params[:password]) || user&.authenticate_recovery_password(params[:password])
      session = user.sessions.create(session_params)
      render json: session_json(session:, user:), status: :created
    else
      render json: { mssg: "Teléfono o contraseña incorrectos." }, status: :unprocessable_entity
    end
  end

  def update
    current_session.assign_attributes(session_params)
    render json: session_json, status: :ok
  end

  def logout
    render json: { status: :ok }
  end

  private

  def session_params
    params.require(:session).permit(
      :push_token,
    )
  end
end

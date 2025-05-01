# frozen_string_literal: true

class Api::V1::SessionsController < ApiApplicationController
  skip_before_action :authenticated, only: [ :login ]

  def login
    user = User.where(phone: params[:phone]).first
    if user&.authenticate(params[:password])
      session = user.sessions.create
      render json: { user: user.as_json(except: [ :password, :password_digest ]).merge(token: session.token) }, status: :created
    else
      render json: { mssg: "Teléfono o contraseña incorrectos." }, status: :unprocessable_entity
    end
  end

  def logout
    render json: { status: :ok }
  end
end

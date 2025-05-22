# frozen_string_literal: true

class Api::V1::SessionsController < ApiApplicationController
  skip_before_action :authenticated, only: [ :login ]

  def login
    user = User.where(phone: params[:phone]).first
    if user&.authenticate(params[:password])
      session = user.sessions.create(session_params)
      render json: session_json(session:), status: :created
    else
      render json: { mssg: "Teléfono o contraseña incorrectos." }, status: :unprocessable_entity
    end
  end

  def update
    current_session.assign_attributes(session_params)
    if current_session.save
      render json: session_json, status: :created
    else
      render json: { mssg: "Error al actualizar: " + current_session.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def logout
    render json: { status: :ok }
  end

  private
  def session_json(session: self.current_session)
    session_hash = session.as_json(only: [ :token, :push_token ])
    {
      user: session.user.as_json(
        except: [ :password, :password_digest ]
      ).merge(session_hash).merge(session_id: session.id)
    }
  end

  def session_params
    params.require(:session).permit(
      :push_token,
    )
  end
end

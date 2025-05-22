class ApiApplicationController < ActionController::API
  before_action :authenticated
  attr_accessor :current_session, :current_user

  private

  def authenticated
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    self.current_session = Session.where(token: token).first
    return render json: { mssg: "Invalid token" }, status: :unauthorized unless @current_session&.is_enabled

    self.current_user = self.current_session.user
  end

  def session_json(session: self.current_session)
    session_hash = session.as_json(only: [ :token, :push_token ])
    {
      user: session.user.as_json(
        except: [ :password, :password_digest ]
      ).merge(session_hash).merge(session_id: session.id)
    }
  end
end

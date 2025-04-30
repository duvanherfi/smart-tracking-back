class ApiApplicationController < ActionController::API
  before_action :authenticated
  attr_accessor :current_session, :current_user

  private

  def authenticated
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    self.current_session = Session.where(token: token).first
    return render json: { error: "Invalid token" }, status: :unauthorized unless @current_session&.is_enabled

    self.current_user = self.current_session.user
  end
end

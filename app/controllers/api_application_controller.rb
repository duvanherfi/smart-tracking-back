class ApiApplicationController < ActionController::API
  before_action :authenticated

  private

  def authenticated
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    @current_session = Session.where(token: token).first
    return render json: { error: "Invalid token" }, status: :unauthorized unless @current_session&.is_enabled

    @current_user = @current_session.user
  end
end

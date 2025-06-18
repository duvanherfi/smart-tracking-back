class Api::V1::UserNotificationsController < ApiApplicationController

  def index
    @user_notifications = current_user.user_notifications
    render json: Api::V1::UserNotificationSerializer.many(@user_notifications)
  end
end

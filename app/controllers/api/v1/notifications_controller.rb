class Api::V1::NotificationsController < ApiApplicationController
  before_action :set_notification, only: %i[ show toggle_enabled ]

  def index
    @notifications = current_user.notifications
    render json: Api::V1::NotificationSerializer.many(@notifications)
  end

  def show
    render json: @notification
  end

  def toggle_enabled
    @notification.toggle_enabled
    render json: Api::V1::NotificationSerializer.one(@notification)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params.expect(:id))
    end
end

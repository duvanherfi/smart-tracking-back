class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :is_enabled, type: Mongoid::Boolean, default: true

  belongs_to :user, inverse_of: :notifications

  validates :name, presence: true, uniqueness: true

  def destroy(options = nil)
    self.is_enabled = false
    self.save
  end

  def toggle_enabled
    self.is_enabled = !self.is_enabled
    self.save
  end

  def self.update_from_server(user:)
    return if user.nil?

    service = GpsService.new
    service.login
    response_notification = service.notifications&.dig("data")
    return if response_notification.nil? || response_notification.empty?

    response_notification.each do |c, v|
      existing_notification = Notification.where(
        name: c,
        user: user
      ).first_or_create
      if existing_notification
        existing_notification.is_enabled = v
        existing_notification.save if existing_notification.changed_attributes.any?
      end
    end
  end
end

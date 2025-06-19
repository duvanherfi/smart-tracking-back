require 'rails_helper'

RSpec.describe UserNotification, type: :model do
  it 'can create from server' do
    user = create(:user)
    create(:vehicle, user:, external_id: "23376")

    service = GpsService.new
    service.login
    response = service.user_notifications("23376")["data"].first
    user_notification = UserNotification.new
    success = user_notification.build_from_server(response)
    expect(success).to be_truthy
    expect(UserNotification.count).to eq(1)
  end
end

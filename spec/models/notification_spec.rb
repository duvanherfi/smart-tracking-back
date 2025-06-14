require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:valid_attributes) {
    {
      name: 'name',
      is_enabled: true,
      user: create(:user)
    }
  }
  let(:invalid_attributes) {
    {
      name: '',
      is_enabled: true
    }
  }

  it "is valid with valid attributes" do
    notification = Notification.new(valid_attributes)
    expect(notification).to be_valid
    expect(notification.save).to be(true)
    expect(notification.persisted?).to be(true)
  end

  it "is not valid without a name" do
    notification = Notification.new(invalid_attributes)
    expect(notification).to_not be_valid
    expect(notification.save).to be(false)
    expect(notification.persisted?).to be(false)
  end

  it "can disabled notification" do
    notification = create(:notification)
    expect(notification.destroy).to be(true)
    expect(notification.is_enabled).to be(false)
  end

  it 'can create from server' do
    user = create(:user)
    expect(Notification.count).to eq(0)
    Notification.update_from_server(user:)
    expect(Notification.count).to be > 0
  end
end

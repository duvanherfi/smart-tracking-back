require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(name: "John Doe", email: "jhon@gmail.com", phone: "1234567890", password: "password", password_confirmation: "password")
    expect(user).to be_valid
    expect(user.save).to be(true)
    expect(user.persisted?).to be(true)
  end

  it "is not valid without a name" do
    user = User.new(name: nil, email: "jhon@gmail.com", phone: "1234567890", password: "password", password_confirmation: "password")
    expect(user).to_not be_valid
    expect(user.save).to be(false)
    expect(user.persisted?).to be(false)
  end
end

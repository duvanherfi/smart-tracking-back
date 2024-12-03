require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(name: "John Doe", email: "jhon@gmail.com", phone: "1234567890", password: "password", password_confirmation: "password")
    expect(user).to be_valid
  end

  it "is not valid without a name" do
    user = User.new(name: nil, email: "jhon@gmail.com", phone: "1234567890", password: "password", password_confirmation: "password")
    expect(user).to_not be_valid
  end
end

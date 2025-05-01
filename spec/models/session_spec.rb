require 'rails_helper'

RSpec.describe Session, type: :model do
  it "generate_token" do
    user = create(:user)
    session = Session.new(user: user)
    session.generate_token
    expect(session).to be_valid
    expect(session.save).to be(true)
    expect(session.token).not_to be_nil
  end
end

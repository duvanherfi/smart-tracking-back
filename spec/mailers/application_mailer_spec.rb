require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  it "includes url helpers" do
    ApplicationMailer.send(:include, Rails.application.routes.url_helpers)
  end
end

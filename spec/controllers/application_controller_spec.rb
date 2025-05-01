require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  describe "inheritance" do
    it "is a ActionController::Base" do
      expect(described_class < ActionController::Base).to be true
    end
  end
end

require 'rails_helper'

RSpec.describe Api::V1, type: :module do
  describe "Call Module" do
    it "it's defined with module" do
      expect(defined?(Api::V1)).to eq("constant")
      expect(Api::V1).to be_a(Module)
    end
  end
end

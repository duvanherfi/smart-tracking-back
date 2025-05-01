require 'rails_helper'

RSpec.describe Api, type: :module do
  describe "Call Module" do
    it "it's defined with module" do
      expect(defined?(Api)).to eq("constant")
      expect(Api::V1).to be_a(Module)
    end
  end
end

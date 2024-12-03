require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  it "is a module" do
    expect(ApplicationJob).to be_a(Module)
  end
end

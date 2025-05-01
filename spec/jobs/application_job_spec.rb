require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  it "hereda de ActiveJob::Base" do
    expect(ApplicationJob).to be < ActiveJob::Base
  end

  context "manejo de excepciones" do
    it "reintenta en caso de Deadlock" do
      expect(ApplicationJob).to respond_to(:retry_on)
    end

    it "descarta trabajos en caso de errores de deserialización" do
      expect(ApplicationJob).to respond_to(:discard_on)
    end
  end
end

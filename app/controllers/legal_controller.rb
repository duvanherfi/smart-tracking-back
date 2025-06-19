class LegalController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "legal", page_size: "legal"
      end
    end
  end
end

class BusinessSupportController < ApplicationController

  before_filter :set_expiry

  def search
    schemes = []
    @count = schemes.size
    @json = schemes.to_json

    respond_to do |format|
      format.json
    end
  end

end

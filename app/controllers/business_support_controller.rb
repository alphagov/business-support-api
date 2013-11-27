class BusinessSupportController < ApplicationController

  before_filter :set_expiry

  def search
    facet_params = params.select { |k,v| Scheme::FACET_KEYS.include?(k.to_sym) }.symbolize_keys
    schemes = Scheme.lookup(facet_params)
    @count = schemes.size
    @json = schemes.to_json

    respond_to do |format|
      format.json
    end
  end

end

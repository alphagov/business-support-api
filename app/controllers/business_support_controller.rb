class BusinessSupportController < ApplicationController

  before_filter :set_expiry

  def search
    @schemes = Scheme.lookup(filtered_params)
    @schemes.populate_page_links { |page_number| url_for params.merge({:page_number => page_number}) }

    respond_to do |format|
      format.json
    end
  end

  private

  def filtered_params
    valid_keys = Scheme::FACET_KEYS + [:page_number, :page_size]
    params.select { |k,v| valid_keys.include?(k.to_sym) }.symbolize_keys
  end
end

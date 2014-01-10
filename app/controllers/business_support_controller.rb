class BusinessSupportController < ApplicationController

  before_filter :set_expiry

  def search
    @schemes = Scheme.lookup(filtered_params)
    @schemes.populate_page_links { |page_number| pagination_url(page_number) }

    respond_to do |format|
      format.json
    end
  end

  def show
    @scheme = Scheme.find_by_slug(params[:slug])

    respond_to do |format|
      format.json
    end
  end

  private

  def filtered_params
    valid_keys = Scheme::FACET_KEYS + [:page_number, :page_size]
    params.select { |k,v| valid_keys.include?(k.to_sym) }.symbolize_keys
  end

  # Returns a pagination url to be used in the JSON response.
  #
  # When requested through the public_api endpoint (distunguised by the
  # presence of the `API-PREFIX` HTTP header), this is the public API URL.
  #
  # For other requests, this is the business-support-schemes URL.
  def pagination_url(page_number)
    api_prefix = request.headers["HTTP_API_PREFIX"]
    if api_prefix.present?
      path_with_query = url_for(params.merge({:page_number => page_number, :only_path => true}))
      "#{Plek.current.website_root}/#{api_prefix}#{path_with_query}"
    else
      url_for(params.merge({:page_number => page_number}))
    end
  end

end

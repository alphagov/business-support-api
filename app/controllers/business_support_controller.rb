require 'url_helper'
require 'pagination'

class BusinessSupportController < ApplicationController

  before_filter :set_expiry
  before_filter :only_json
  before_filter :warning_http_header

  include Pagination

  def search
    schemes = Scheme.lookup(filtered_params)

    if schemes.empty? or api_prefix
      page_size = params[:page_size]
    else
      page_size = schemes.size
    end

    schemes = paginate(schemes, params[:page_number], page_size)
    link_helper = UrlHelper.new(api_prefix, filtered_params, schemes)

    respond_to do |format|
      format.json { render json: PaginationPresenter.new(schemes, link_helper) }
    end
  end

  def show
    scheme = Scheme.find_by_slug(params[:slug])

    respond_to do |format|
      format.json { render json: SchemePresenter.new(scheme, UrlHelper.new(api_prefix, filtered_params)) }
    end
  rescue Scheme::RecordNotFound
    respond_to do |format|
      format.json { render json: { error: "scheme '#{params[:slug]}' not found"}, status: 404 }
    end
  rescue Scheme::RecordGone
    respond_to do |format|
      format.json { render json: { error: "scheme '#{params[:slug]}' withdrawn"}, status: 410 }
    end
  end

  private

  def filtered_params
    valid_keys = Scheme::FACET_KEYS + [:postcode, :page_number, :page_size]
    params.select { |k,v| valid_keys.include?(k.to_sym) }.symbolize_keys
  end

  def api_prefix
    request.headers["HTTP_API_PREFIX"]
  end

  def only_json
    render :nothing => true, :status => 406 unless params[:format] == 'json'
  end

  def warning_http_header
    response.headers["Warning"] = '299 - "The business support API is now deprecated and will be removed on Monday 24 April 2017; please use https://www.gov.uk/api/search.json?filter_document_type=business_finance_support_scheme instead to get all schemes"'
  end

end

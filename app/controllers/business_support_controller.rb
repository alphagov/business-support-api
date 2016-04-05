require 'url_helper'
require 'pagination'

class BusinessSupportController < ApplicationController

  before_filter :set_expiry
  before_filter :only_json

  include Pagination

  def search
    schemes = Scheme.lookup(filtered_params)

    if schemes.empty? or api_prefix
      page_size = params[:page_size]
    else
      page_size = schemes.size
    end

    schemes = paginate(schemes, params[:page_number], page_size)
    link_helper = UrlHelper.new(api_prefix, params, schemes)

    respond_to do |format|
      format.json { render json: PaginationPresenter.new(schemes, link_helper) }
    end
  end

  def show
    scheme = Scheme.find_by_slug(params[:slug])

    respond_to do |format|
      format.json { render json: SchemePresenter.new(scheme, UrlHelper.new(api_prefix, params)) }
    end
  rescue Scheme::RecordNotFound
    respond_to do |format|
      format.json { render json: { error: "scheme '#{params[:slug]}' not found"}, status: 404 }
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

end

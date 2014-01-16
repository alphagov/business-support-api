require 'page_link_helper'
require 'pagination'

class BusinessSupportController < ApplicationController

  before_filter :set_expiry

  include Pagination

  def search
    schemes = Scheme.lookup(filtered_params)
    api_prefix = request.headers["HTTP_API_PREFIX"]

    if schemes.empty? or api_prefix
      page_size = params[:page_size]
    else
      page_size = schemes.size
    end

    schemes = paginate(schemes, params[:page_number], page_size)
    link_helper = PageLinkHelper.new(schemes, view_context)

    respond_to do |format|
      format.json { render json: PaginationPresenter.new(schemes, link_helper) }
    end
  end

  def show
    scheme = Scheme.find_by_slug(params[:slug])

    respond_to do |format|
      format.json { render json: SchemePresenter.new(scheme, view_context) }
    end
  end

  private

  def filtered_params
    valid_keys = Scheme::FACET_KEYS + [:page_number, :page_size]
    params.select { |k,v| valid_keys.include?(k.to_sym) }.symbolize_keys
  end

end

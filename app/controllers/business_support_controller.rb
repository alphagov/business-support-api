class BusinessSupportController < ApplicationController

  before_filter :set_expiry

  def search
    @schemes = Scheme.lookup(filtered_params)

    respond_to do |format|
      format.json { render json: PaginatedResultSetPresenter.new(@schemes, view_context) }
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

end

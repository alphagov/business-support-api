class PaginatedResultSetPresenter

  def initialize(result_set, view_context)
    @result_set = result_set
    @view_context = view_context

    @result_set.populate_page_links { |page_number| pagination_url(page_number) }
  end

  def as_json(options={})
    {
      :_response_info => {
        :status => "ok",
        :links => @result_set.links,
      },
      :total => @result_set.total,
      :start_index => @result_set.start_index,
      :page_size => @result_set.results.size,
      :current_page => @result_set.page_number,
      :pages => @result_set.pages,
      :results => @result_set.results
    }
  end

  def pagination_url(page_number)
    page_params = @view_context.params.merge({:page_number => page_number})
    api_prefix = @view_context.request.headers["HTTP_API_PREFIX"]

    if api_prefix.present?
      path_with_query = @view_context.url_for(page_params.merge({:only_path => true}))
      "#{Plek.current.website_root}/#{api_prefix}#{path_with_query}"
    else
      @view_context.url_for(page_params)
    end
  end
end

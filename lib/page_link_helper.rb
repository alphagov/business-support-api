require 'link_header'

class PageLinkHelper

  def initialize(results, view_context)
    @results = results
    @view_context = view_context
  end

  def links
    links = []

    unless @results.last_page?
      links.push LinkHeader::Link.new(
        pagination_url(@results.page_number + 1),
        [["rel", "next"]]
      )
    end
    unless @results.first_page?
      links.push LinkHeader::Link.new(
        pagination_url(@results.page_number - 1),
        [["rel", "previous"]]
      )
    end

    links
  end

  private

  def pagination_url(page_number)
    page_params = @view_context.params.merge({:page_number => page_number})
    api_prefix = @view_context.request.headers["HTTP_API_PREFIX"]

    if api_prefix.present?
      path_with_query = @view_context.url_for(page_params.merge(:only_path => true))
      "#{Plek.current.website_root}/#{api_prefix}#{path_with_query}"
    else
      @view_context.url_for(page_params)
    end
  end
end

require 'link_header'

class UrlHelper

  include Rails.application.routes.url_helpers

  attr_reader :api_prefix, :params, :results

  def initialize(api_prefix=nil, params={}, results=nil)
    @api_prefix = api_prefix
    @params = params
    @results = results
  end

  def links
    links = []

    unless results.last_page?
      links.push LinkHeader::Link.new(
        pagination_url(results.page_number + 1),
        [["rel", "next"]]
      )
    end
    unless results.first_page?
      links.push LinkHeader::Link.new(
        pagination_url(results.page_number - 1),
        [["rel", "previous"]]
      )
    end

    links
  end

  def update_scheme_urls(schemes)
    schemes.map do |scheme|
      scheme.id = build_scheme_url(scheme.id)
      scheme
    end
  end

  def build_scheme_url(orig_url)
    url = Plek.current.website_root
    url += '/' + api_prefix if api_prefix.present?
    url += scheme_path(slug: extract_slug(orig_url), format: :json)
    url
  end

  private

  def pagination_url(page_number)
    page_params = params.merge({page_number: page_number, format: :json})

    url = Plek.current.website_root
    url += '/' + api_prefix if api_prefix.present?
    url += schemes_path(page_params)
    url
  end

  def extract_slug(url)
    path = URI(url).path
    slug_with_format = path.split('/').last
    slug_with_format.split('.').first
  end
end

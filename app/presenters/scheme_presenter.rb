class SchemePresenter

  def initialize(scheme, view_context)
    @scheme = scheme
    @view_context = view_context
  end

  def as_json(options={})
    attrs = @scheme.marshal_dump
    attrs[:id] = url_for_id(attrs[:web_url])
    valid_keys = [:id, :identifier, :title, :details, :web_url, :priority] + Scheme::FACET_KEYS
    attrs.select { |k,v| valid_keys.include?(k.to_sym) }
  end

  def url_for_id(url)
    api_prefix = @view_context.request.headers["HTTP_API_PREFIX"]
    uri = URI(url)
    slug = uri.path.split('/').last
    if api_prefix
      "#{Plek.current.website_root}/#{api_prefix}#{@view_context.url_for(format: :json, slug: slug, only_path: true)}"
    else
      @view_context.scheme_url(format: :json, slug: slug)
    end
  end
end

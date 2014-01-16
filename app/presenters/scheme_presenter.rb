class SchemePresenter

  def initialize(scheme, view_context)
    @scheme = scheme
    @view_context = view_context
  end

  def as_json(options={})
    attrs = @scheme.marshal_dump
    attrs[:id] = format_id_url(attrs[:id])
    valid_keys = [:id, :identifier, :title, :details, :web_url, :priority] + Scheme::FACET_KEYS
    attrs.select { |k,v| valid_keys.include?(k.to_sym) }
  end

  def format_id_url(url)
    api_prefix = @view_context.request.headers["HTTP_API_PREFIX"]
    uri = URI(url)
    slug_with_format = uri.path.split('/').last
    if api_prefix
      "#{Plek.current.website_root}/#{api_prefix}/business-support-schemes/#{slug_with_format}"
    else
      url
    end
  end
end

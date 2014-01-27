class SchemePresenter

  def initialize(scheme, url_helper)
    @scheme = scheme
    @url_helper = url_helper
  end

  def as_json(options={})
    attrs = @scheme.marshal_dump
    attrs[:id] = @url_helper.build_scheme_url(attrs[:id])
    valid_keys = [:id, :identifier, :title, :details, :web_url, :priority] + Scheme::FACET_KEYS
    attrs.select { |k,v| valid_keys.include?(k.to_sym) }
  end
end

class SchemePresenter

  def initialize(scheme, url_helper)
    @scheme = scheme
    @url_helper = url_helper
  end

  def as_json(options={})
    attrs = @scheme.as_json
    attrs[:id] = @url_helper.build_scheme_url(attrs[:id])
    valid_keys = [:id, :identifier, :title, :details, :web_url, :priority] + Scheme::FACET_KEYS
    scheme = attrs.select { |k,v| valid_keys.include?(k.to_sym) }
    scheme[:_warning] = "The business support API is now deprecated and will be removed on Monday 24 April 2017; please use https://www.gov.uk/api/search.json?filter_document_type=business_finance_support_scheme instead to get all schemes"
    scheme
  end
end

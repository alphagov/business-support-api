require 'webmock'
require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/imminence'

RSpec.configure do |config|
  config.include GdsApi::TestHelpers::ContentApi, :type => :controller
  config.before(:each, :type => :controller) do
    stub_content_api_default_artefact
    content_api_has_default_business_support_schemes
  end

  config.include GdsApi::TestHelpers::ContentApi, :type => :feature
  config.before(:each, :type => :feature) do
    stub_content_api_default_artefact
    setup_content_api_business_support_schemes_stubs
  end
end

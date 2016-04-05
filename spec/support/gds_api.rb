require 'webmock'
require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/imminence'

RSpec.configure do |config|
  config.include GdsApi::TestHelpers::ContentApi, :type => :controller

  config.include GdsApi::TestHelpers::ContentApi, :type => :feature
  config.before(:each, :type => :feature) do
    setup_content_api_business_support_schemes_stubs
  end
  config.include GdsApi::TestHelpers::Imminence, :type => :feature
end

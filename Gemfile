source 'https://rubygems.org'

gem 'rails', '3.2.15'

gem 'unicorn', '4.6.3'
gem 'exception_notification', '4.0.1'
gem 'aws-ses', '0.5.0', :require => 'aws/ses'
gem 'link_header', '0.0.7'

gem 'plek', '1.1.0'
gem 'logstasher', '0.4.1'

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '7.17.1'
end

group :development, :test do
  gem 'capybara', '2.1.0'
  gem 'rspec-rails', '2.14.0'
  gem 'simplecov-rcov', '0.2.3', :require => false
  gem 'ci_reporter', '1.9.0'
  gem 'webmock', '1.11.0', :require => false
end

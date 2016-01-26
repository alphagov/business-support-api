source 'https://rubygems.org'

gem 'rails', '4.1.14.1'

gem 'unicorn', '4.6.3'
gem 'link_header', '0.0.7'

gem 'plek', '1.7.0'
gem 'logstasher', '0.4.8'
gem 'airbrake', '3.1.15'

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
 gem 'gds-api-adapters', '20.1.1'
end

group :development, :test do
  gem 'capybara', '2.1.0'
  gem 'rspec-rails', '2.14.0'
  gem 'simplecov-rcov', '0.2.3', :require => false
  gem 'ci_reporter', '1.9.0'
  gem 'webmock', '1.11.0', :require => false
  gem 'minitest', '5.5.1'
end

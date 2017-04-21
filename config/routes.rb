BusinessSupportApi::Application.routes.draw do
  get '/healthcheck' => proc { [200, {}, ['OK']] }
  get '/business-support-schemes/:slug', :to => 'business_support#return_warning_header_and_no_content', :as => :scheme
  get '/business-support-schemes', :to => 'business_support#return_warning_header_and_no_content', :as => :schemes
end

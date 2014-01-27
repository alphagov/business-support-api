BusinessSupportApi::Application.routes.draw do
  get '/healthcheck' => proc { [200, {}, ['OK']] }
  get '/business-support-schemes/:slug', :to => 'business_support#show', :as => :scheme
  get '/business-support-schemes', :to => 'business_support#search', :as => :schemes
end

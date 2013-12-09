BusinessSupportApi::Application.routes.draw do
  get '/healthcheck' => proc { [200, {}, ['OK']] }
  get '/business-support-schemes/:slug', :to => 'business_support#show'
  get '/business-support-schemes', :to => 'business_support#search'
  get '/business-support-schemes/index', :to => 'business_support#search'
end

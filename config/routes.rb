BusinessSupportApi::Application.routes.draw do
  get '/healthcheck' => proc { [200, {}, ['OK']] }
  get '/search', :to => 'business_support#search'
end

require 'spec_helper'
require 'pagination'

feature 'serving business support schemes' do
  it "should build appropriate pagination urls when requested through the public API" do
    Plek.any_instance.stub(:website_root).and_return("https://www.gov.uk")
    Scheme.stub(:lookup).and_return(
      Pagination::PaginatedResultSet.new({"title" => "Super funding", "identifier" => "123"}, 2, 25, 100))

    get '/business-support-schemes', { :format => :json, :page_size => 25 }, { 'HTTP_API_PREFIX' => 'api' }

    response.should be_success
    search_response = JSON.load(response.body)
    links = search_response["_response_info"]["links"]
    links.first["href"].should == "https://www.gov.uk/api/business-support-schemes.json?page_number=3&page_size=25"
    links.last["href"].should == "https://www.gov.uk/api/business-support-schemes.json?page_number=1&page_size=25"
  end
end
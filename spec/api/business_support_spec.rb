require 'spec_helper'
require 'pagination'

describe 'serving business support schemes', type: :request do
  it "should build appropriate pagination urls when requested through the public API" do
    allow_any_instance_of(Plek).to receive(:website_root).and_return("https://www.gov.uk")
    schemes = [].tap do |ary|
      100.times do |n|
        ary << Scheme.new({"id" => "http://www.gov.uk/super-funding.json",
                           "title" => "Super funding #{n+1}"})
      end
    end
    allow(Scheme).to receive(:lookup).and_return(schemes)

    get '/business-support-schemes', { :format => :json, :page_number => 2, :page_size => 25 },
      { 'HTTP_API_PREFIX' => 'api' }

    expect(response).to be_success
    search_response = JSON.load(response.body)
    links = search_response["_response_info"]["links"]
    expect(links.first["href"]).to eq("https://www.gov.uk/api/business-support-schemes.json?page_number=3&page_size=25")
    expect(links.last["href"]).to eq("https://www.gov.uk/api/business-support-schemes.json?page_number=1&page_size=25")
  end
end

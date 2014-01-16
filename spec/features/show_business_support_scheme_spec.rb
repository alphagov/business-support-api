require 'spec_helper'

describe "View a business support scheme" do
  before do
    stub_request(:get, "#{Plek.new.find('contentapi')}/graduate-start-up.json")
      .to_return(:status => 200, :body => {
        "id" => "https://www.gov.uk/graduate-start-up.json",
        "title" => "Graduate start up",
        "format" => "business_support",
        "web_url" => "https://www.gov.uk/graduate-start-up",
        "super_secret_field" => "You ain't seen me",
        "details" => { "short_description" => "Some blurb abour the Graduate start-up scheme",
                       "body" => "More about the scheme, all the detailed explanation." } }.to_json)

    visit '/business-support-schemes/graduate-start-up.json'
  end
  it "should display the details for the scheme" do
    parsed_response = JSON.parse(page.body)

    parsed_response["id"].should == "https://www.gov.uk/graduate-start-up.json"
    parsed_response["title"].should == "Graduate start up"
    parsed_response["web_url"].should == "https://www.gov.uk/graduate-start-up"
    parsed_response.keys.should_not include("super_secret_field")
    parsed_response["details"]["short_description"].should == "Some blurb abour the Graduate start-up scheme"
    parsed_response["details"]["body"].should == "More about the scheme, all the detailed explanation."
  end
end

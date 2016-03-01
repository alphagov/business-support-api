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

    allow_any_instance_of(Plek).to receive(:website_root).and_return("https://www.gov.uk")

    visit '/business-support-schemes/graduate-start-up.json'
  end
  it "should display the details for the scheme" do
    parsed_response = JSON.parse(page.body)

    expect(parsed_response["id"]).to eq("https://www.gov.uk/business-support-schemes/graduate-start-up.json")
    expect(parsed_response["title"]).to eq("Graduate start up")
    expect(parsed_response["web_url"]).to eq("https://www.gov.uk/graduate-start-up")
    expect(parsed_response.keys).not_to include("super_secret_field")
    expect(parsed_response["details"]["short_description"]).to eq("Some blurb abour the Graduate start-up scheme")
    expect(parsed_response["details"]["body"]).to eq("More about the scheme, all the detailed explanation.")
  end
end

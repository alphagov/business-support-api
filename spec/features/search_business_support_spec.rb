require 'spec_helper'

describe "Search for business support" do
  before do
    content_api_has_business_support_scheme(
      "title" => "Graduate start-up scheme",
      "web_url" => "https://www.gov.uk/graduate-start-up",
      "identifier" => "graduate-start-up",
      "short_description" => "Some blurb abour the Graduate start-up scheme")
    content_api_has_business_support_scheme(
      "title" => "Manufacturing Services scheme - Wales",
      "web_url" => "https://www.gov.uk/wales/manufacturing-services-scheme",
      "identifier" => "manufacturing-services-wales",
      "short_description" => "Some blurb abour the welsh Manufacturing services scheme")
    imminence_has_business_support_schemes(
      nil,
      [
        {"title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up"},
        {"title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales"},
      ]
    )
    imminence_has_business_support_schemes(
      {
        "support_types" => "finance,equity,grant,loan,expertise-and-advice,recognition-award",
      },
      [
        { "title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up",
                      "support_types" => ["finance", "equity", "grant", "loan", "expertise-and-advice", "recognition-award"] },
        { "title" => "Manufacturing Services - Wales", "business_support_identifier" => "manufacturing-services-wales",
                      "support_types" => ["finance", "equity", "grant", "loan", "expertise-and-advice", "recognition-award"] },
      ]
    )
    imminence_has_business_support_schemes(
      {
      "stages" => "grow-and-sustain",
      "business_sizes" => "up-to-249",
      "sectors" => "education",
      "locations" => "london",
      },
      [
        { "title" => "Graduate start-up", "business_support_identifier" => "graduate-start-up",
        "stages" => ["grow-and-sustain"], "business_sizes" => ["up-to-249"], "sectors" => ["education"],
        "locations" => ["london"], "support_types" => ["finance", "equity", "grant", "expertise-and-advice"] },
      ]
    )
  end
  it "should return all schemes where no filtering facets are specified" do
    visit "/business-support-schemes.json"

    parsed_response = JSON.parse(page.body)
    parsed_response["total"].should == 2
    results = parsed_response["results"]
    results.first["title"].should == "Graduate start-up scheme"
    results.second["title"].should == "Manufacturing Services scheme - Wales"
  end
  it "should render suitable schemes as json" do
    visit "/business-support-schemes.json?business_sizes=up-to-249&locations=london&sectors=education&stages=grow-and-sustain"

    parsed_response = JSON.parse(page.body)
    parsed_response["total"].should == 1
    parsed_response["page_size"].should == 1
    parsed_response["current_page"].should == 1
    parsed_response["start_index"].should == 1
    parsed_response["pages"].should == 1
    results = parsed_response["results"]
    results.first["title"].should == "Graduate start-up scheme"
    results.first["locations"].should == ["london"]
  end
end

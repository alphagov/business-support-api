require 'spec_helper'

describe "Search for business support" do
  before do
    @graduate_start_up_attrs = {
      "id" => "https://www.gov.uk/graduate-start-up.json",
      "title" => "Graduate start-up scheme",
      "web_url" => "https://www.gov.uk/graduate-start-up",
      "identifier" => "graduate-start-up",
      "short_description" => "Some blurb abour the Graduate start-up scheme"}
    @manufacturing_services_wales_attrs = {
      "id" => "https://www.gov.uk/wales/manufacturing-services-scheme.json",
      "title" => "Manufacturing Services scheme - Wales",
      "web_url" => "https://www.gov.uk/wales/manufacturing-services-scheme",
      "identifier" => "manufacturing-services-wales",
      "short_description" => "Some blurb about the welsh Manufacturing services scheme"
    }
    content_api_has_business_support_scheme(@graduate_start_up_attrs, {})
    content_api_has_business_support_scheme(@manufacturing_services_wales_attrs, {})
  end
  it "should return all schemes where no filtering facets are specified" do
    visit "/business-support-schemes.json"
    parsed_response = JSON.parse(page.body)
    parsed_response["total"].should == 2
    results = parsed_response["results"]
    results.first["title"].should == "Graduate start-up scheme"
    results.second["title"].should == "Manufacturing Services scheme - Wales"
  end

  describe "with filtering parameters" do
    before do
      facets = {"support_types" => ["finance", "equity", "grant", "loan", "expertise-and-advice", "recognition-award"]}
      content_api_has_business_support_scheme(@manufacturing_services_wales_attrs.merge(facets), facets)
    end
    it "should filter the schemes by facet values" do
       facets = {
          "areas" => ["london"],
          "business_sizes" => ["up-to-249"],
          "sectors" => ["education"],
          "stages" => ["grow-and-sustain"]
        }
      content_api_has_business_support_scheme(@graduate_start_up_attrs.merge(facets), facets)

      visit "/business-support-schemes.json?areas=london&business_sizes=up-to-249&sectors=education&stages=grow-and-sustain"

      parsed_response = JSON.parse(page.body)
      parsed_response["total"].should == 1
      parsed_response["page_size"].should == 1
      parsed_response["current_page"].should == 1
      parsed_response["start_index"].should == 1
      parsed_response["pages"].should == 1
      results = parsed_response["results"]
      results.first["title"].should == "Graduate start-up scheme"
      results.first["areas"].should == ["london"]
    end

    it "should filter the schemes by facet values and areas" do
      imminence_has_areas_for_postcode("WC2B%206SE",[{"slug" => "london", "name" => "London", "type" => "EUR"}])
      facets = {
          "areas" => ["london", "wales", "scotland"],
          "business_sizes" => ["up-to-249"],
          "sectors" => ["education"],
          "stages" => ["grow-and-sustain"]
        }
      content_api_has_business_support_scheme(@graduate_start_up_attrs.merge(facets), facets)

      visit "/business-support-schemes.json?postcode=WC2B%206SE&business_sizes=up-to-249&sectors=education&stages=grow-and-sustain"

      parsed_response = JSON.parse(page.body)
      parsed_response["total"].should == 1
      parsed_response["page_size"].should == 1
      parsed_response["current_page"].should == 1
      parsed_response["start_index"].should == 1
      parsed_response["pages"].should == 1
      results = parsed_response["results"]
      results.first["title"].should == "Graduate start-up scheme"
      results.first["areas"].should == ["london","wales","scotland"]
    end

    it "should return no results with an incomplete postcode" do
      imminence_has_areas_for_postcode("WC2B",[])
      facets = { "areas" => ["london", "wales", "scotland"] }
      content_api_has_business_support_scheme(@graduate_start_up_attrs.merge(facets), facets)

      visit "/business-support-schemes.json?postcode=WC2B"

      parsed_response = JSON.parse(page.body)
      parsed_response["total"].should == 0
    end

  end
end

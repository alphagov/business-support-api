require 'rails_helper'
require 'url_helper'

describe "SchemePresenter" do
  it "should format the scheme as json" do
    allow_any_instance_of(Plek).to receive(:website_root).and_return("http://test.gov.uk")
    warning = "The business support API is now deprecated and will be removed on Tuesday 18 April 2017; please use https://www.gov.uk/api/search.json?filter_document_type=business_finance_support_scheme instead to get all schemes"
    scheme = Scheme.new({
      :id => "http://foo.com/bar/baz.json",
      :identifier => "1234",
      :title => "Baz and all that jazz",
      :details => {
        :additional_information => "Bloop"
      },
      :web_url => "http://foo.com/bar/baz",
      :priority => "1"
    })
    presenter = SchemePresenter.new(scheme, UrlHelper.new)
    json_hash = presenter.as_json

    expect(json_hash[:id]).to eq("http://test.gov.uk/business-support-schemes/baz.json")
    expect(json_hash[:identifier]).to eq("1234")
    expect(json_hash[:title]).to eq("Baz and all that jazz")
    expect(json_hash[:details]).to eq({:additional_information => "Bloop"})
    expect(json_hash[:_warning]).to eq(warning)
  end
end

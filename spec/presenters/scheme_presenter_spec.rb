require 'spec_helper'

describe "SchemePresenter" do
  it "should format the scheme as json" do
    Plek.any_instance.stub(:website_root).and_return("http://test.gov.uk")
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

    json_hash[:id].should == "http://test.gov.uk/business-support-schemes/baz.json"
    json_hash[:identifier].should == "1234"
    json_hash[:title].should == "Baz and all that jazz"
    json_hash[:details].should == {:additional_information => "Bloop"}
  end
end

require 'spec_helper'

describe PaginationPresenter do

  it "should initialize pagination values and paging links" do
    Plek.any_instance.stub(:website_root).and_return("http://test.gov.uk")

    schemes = []
    25.times { |n| schemes << Scheme.new({:id => "http://test.gov.uk/scheme#{n+1}.json"}) }

    results = Pagination::PaginatedResultSet.new(schemes, 2, 25, 100)
    url_helper = UrlHelper.new(nil, {:page_number => 2, :page_size => 25}, results)

    presenter = PaginationPresenter.new(results, url_helper)
    json_hash = presenter.as_json

    json_hash[:start_index].should == 26
    json_hash[:page_size].should == 25
    json_hash[:page_number.should] == 2
    json_hash[:total].should == 100
    json_hash[:pages].should == 4
    json_hash[:results].size.should == 25

    links = json_hash[:_response_info][:links]
    links.size.should == 2
    links.first.href.should == "http://test.gov.uk/business-support-schemes.json?page_number=3&page_size=25"
    links.last.href.should == "http://test.gov.uk/business-support-schemes.json?page_number=1&page_size=25"
  end
end

require 'spec_helper'

describe PaginationPresenter do

  it "should initialize pagination values and paging links" do
    schemes = [].tap do |ary|
      25.times { |n| ary << :"scheme#{n+1}" }
    end
    results = Pagination::PaginatedResultSet.new(schemes, 2, 25, 100)
    link_helper = double(:links => [
      LinkHeader::Link.new("http://test.gov.uk/schemes.json?page_number=3&page_size=25",[["rel", "next"]]),
      LinkHeader::Link.new("http://test.gov.uk/schemes.json?page_number=1&page_size=25",[["rel", "previous"]])
    ])

    presenter = PaginationPresenter.new(results, link_helper)
    json_hash = presenter.as_json

    json_hash[:start_index].should == 26
    json_hash[:page_size].should == 25
    json_hash[:page_number.should] == 2
    json_hash[:total].should == 100
    json_hash[:pages].should == 4
    json_hash[:results].size.should == 25

    links = json_hash[:_response_info][:links]
    links.size.should == 2
    links.first.href.should == "http://test.gov.uk/schemes.json?page_number=3&page_size=25"
    links.last.href.should == "http://test.gov.uk/schemes.json?page_number=1&page_size=25"
  end
end

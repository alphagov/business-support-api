require 'spec_helper'

describe "UrlHelper" do
  before do
    Plek.any_instance.stub(:website_root).and_return('http://test.gov.uk')

    @schemes = [].tap do |ary|
      45.times { |n| ary << :"scheme#{n+1}" }
    end

  end
  it "should provide next and previous pagination links" do
    results = Pagination::PaginatedResultSet.new(@schemes, 2, 15, 45)
    helper = UrlHelper.new('api', {:page_number => 2, :page_size => 15}, results)

    helper.links.first.href.should == "http://test.gov.uk/api/business-support-schemes.json?page_number=3&page_size=15"
    helper.links.first.attr_pairs.should == [["rel", "next"]]
    helper.links.last.href.should == "http://test.gov.uk/api/business-support-schemes.json?page_number=1&page_size=15"
    helper.links.last.attr_pairs.should == [["rel", "previous"]]
  end
  it "should only provide necessary links" do
    results = Pagination::PaginatedResultSet.new(@schemes, 1, 15, 45)
    helper = UrlHelper.new('api', {:page_number => 1, :page_size => 15}, results)

    helper.links.size.should == 1
    helper.links.first.href.should == "http://test.gov.uk/api/business-support-schemes.json?page_number=2&page_size=15"
    helper.links.first.attr_pairs.should == [["rel", "next"]]

    results = Pagination::PaginatedResultSet.new(@schemes, 3, 15, 45)
    helper = UrlHelper.new('api', {:page_number => 3, :page_size => 15}, results)

    helper.links.size.should == 1
    helper.links.first.href.should == "http://test.gov.uk/api/business-support-schemes.json?page_number=2&page_size=15"
    helper.links.first.attr_pairs.should == [["rel", "previous"]]
  end
end

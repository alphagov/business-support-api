require 'spec_helper'

describe "PageLinkHelper" do
  before do
    Plek.any_instance.stub(:website_root).and_return('http://test.gov.uk')

    @schemes = [].tap do |ary|
      45.times { |n| ary << :"scheme#{n+1}" }
    end

    @view_context = double(:params => { :page_size => 15 },
      :request => double(:headers => { 'HTTP_API_PREFIX' => 'api' }))
    @view_context.stub(:url_for)
      .with(:page_size => 15, :page_number => 3, :only_path => true)
      .and_return("/schemes.json?page_size=15&page_number=3")
    @view_context.stub(:url_for)
      .with(:page_size => 15, :page_number => 2, :only_path => true)
      .and_return("/schemes.json?page_size=15&page_number=2")
    @view_context.stub(:url_for)
      .with(:page_size => 15, :page_number => 1, :only_path => true)
      .and_return("/schemes.json?page_size=15&page_number=1")
  end
  it "should provide next and previous pagination links" do
    results = Pagination::PaginatedResultSet.new(@schemes, 2, 15, 45)
    helper = PageLinkHelper.new(results, @view_context)

    helper.links.first.href.should == "http://test.gov.uk/api/schemes.json?page_size=15&page_number=3"
    helper.links.first.attr_pairs.should == [["rel", "next"]]
    helper.links.last.href.should == "http://test.gov.uk/api/schemes.json?page_size=15&page_number=1"
    helper.links.last.attr_pairs.should == [["rel", "previous"]]
  end
  it "should only provide necessary links" do
    results = Pagination::PaginatedResultSet.new(@schemes, 1, 15, 45)
    helper = PageLinkHelper.new(results, @view_context)

    helper.links.size.should == 1
    helper.links.first.href.should == "http://test.gov.uk/api/schemes.json?page_size=15&page_number=2"
    helper.links.first.attr_pairs.should == [["rel", "next"]]

    results = Pagination::PaginatedResultSet.new(@schemes, 3, 15, 45)
    helper = PageLinkHelper.new(results, @view_context)

    helper.links.size.should == 1
    helper.links.first.href.should == "http://test.gov.uk/api/schemes.json?page_size=15&page_number=2"
    helper.links.first.attr_pairs.should == [["rel", "previous"]]
  end
end

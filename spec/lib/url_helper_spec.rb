require 'rails_helper'
require 'url_helper'
require 'pagination'

describe UrlHelper do
  before do
    allow_any_instance_of(Plek).to receive(:website_root).and_return('http://test.gov.uk')

    @schemes = [].tap do |ary|
      45.times { |n| ary << :"scheme#{n+1}" }
    end

  end
  it "should provide next and previous pagination links" do
    results = Pagination::PaginatedResultSet.new(@schemes, 2, 15, 45)
    helper = UrlHelper.new('api', {:page_number => 2, :page_size => 15}, results)

    expect(helper.links.first.href).to eq("http://test.gov.uk/api/business-support-schemes.json?page_number=3&page_size=15")
    expect(helper.links.first.attr_pairs).to eq([["rel", "next"]])
    expect(helper.links.last.href).to eq("http://test.gov.uk/api/business-support-schemes.json?page_number=1&page_size=15")
    expect(helper.links.last.attr_pairs).to eq([["rel", "previous"]])
  end
  it "should only provide necessary links" do
    results = Pagination::PaginatedResultSet.new(@schemes, 1, 15, 45)
    helper = UrlHelper.new('api', {:page_number => 1, :page_size => 15}, results)

    expect(helper.links.size).to eq(1)
    expect(helper.links.first.href).to eq("http://test.gov.uk/api/business-support-schemes.json?page_number=2&page_size=15")
    expect(helper.links.first.attr_pairs).to eq([["rel", "next"]])

    results = Pagination::PaginatedResultSet.new(@schemes, 3, 15, 45)
    helper = UrlHelper.new('api', {:page_number => 3, :page_size => 15}, results)

    expect(helper.links.size).to eq(1)
    expect(helper.links.first.href).to eq("http://test.gov.uk/api/business-support-schemes.json?page_number=2&page_size=15")
    expect(helper.links.first.attr_pairs).to eq([["rel", "previous"]])
  end
end

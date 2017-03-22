require 'rails_helper'
require 'pagination'
require 'url_helper'

describe PaginationPresenter do

  it "should initialize pagination values and paging links" do
    allow_any_instance_of(Plek).to receive(:website_root).and_return("http://test.gov.uk")

    warning = "The business support API is now deprecated and will be removed on Monday 24 April 2017; please use https://www.gov.uk/api/search.json?filter_document_type=business_finance_support_scheme instead to get all schemes"
    schemes = []
    25.times { |n| schemes << Scheme.new({:id => "http://test.gov.uk/scheme#{n+1}.json"}) }

    results = Pagination::PaginatedResultSet.new(schemes, 2, 25, 100)
    url_helper = UrlHelper.new(nil, {:page_number => 2, :page_size => 25}, results)

    presenter = PaginationPresenter.new(results, url_helper)
    json_hash = presenter.as_json

    expect(json_hash[:start_index]).to eq(26)
    expect(json_hash[:page_size]).to eq(25)
    expect(json_hash[:current_page]).to eq(2)
    expect(json_hash[:total]).to eq(100)
    expect(json_hash[:pages]).to eq(4)
    expect(json_hash[:results].size).to eq(25)
    expect(json_hash[:_warning]).to eq(warning)

    links = json_hash[:_response_info][:links]
    expect(links.size).to eq(2)
    expect(links.first.href).to eq("http://test.gov.uk/business-support-schemes.json?page_number=3&page_size=25")
    expect(links.last.href).to eq("http://test.gov.uk/business-support-schemes.json?page_number=1&page_size=25")
  end
end

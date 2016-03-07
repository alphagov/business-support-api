require 'spec_helper'
require 'pagination'

describe "Pagination" do
  include Pagination
  before do
    @collection = [].tap do |ary|
      198.times { |n| ary << n + 1 }
    end
  end
  it "should paginate with defaults" do
    paged = paginate(@collection, nil, nil)
    expect(paged.total).to eq(198)
    expect(paged.start_index).to eq(1)
    expect(paged.page_number).to eq(1)
    expect(paged.pages).to eq(4)
    expect(paged.page_size).to eq(50)
    expect(paged.first_page?).to eq(true)
    expect(paged.results.size).to eq(50)
    expect(paged.results).to include(1)
    expect(paged.results).to include(50)
  end
  it "should return the correct page" do
    paged = paginate(@collection, 3, 10)
    expect(paged.total).to eq(198)
    expect(paged.start_index).to eq(21)
    expect(paged.pages).to eq(20)
    expect(paged.page_number).to eq(3)
    expect(paged.results).to eq([21,22,23,24,25,26,27,28,29,30])
    paged = paginate(@collection, 20, 10)
    expect(paged.results.size).to eq(8)
    expect(paged.results).to eq([191,192,193,194,195,196,197,198])
  end
  it "should sanitise paging params" do
    paged = paginate(@collection, -1000, -1)
    expect(paged.page_size).to eq(50)
    expect(paged.page_number).to eq(1)

    paged = paginate(@collection, 500, 50)
    expect(paged.page_size).to eq(50)
    expect(paged.page_number).to eq(4)
  end
end

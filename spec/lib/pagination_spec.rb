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
    paged.total.should == 198
    paged.start_index.should == 1
    paged.page_number.should == 1
    paged.pages.should == 4
    paged.page_size.should == 50
    paged.first_page?.should == true
    paged.results.size.should == 50
    paged.results.should include(1)
    paged.results.should include(50)
  end
  it "should return the correct page" do
    paged = paginate(@collection, 3, 10)
    paged.total.should == 198
    paged.start_index.should == 21
    paged.pages.should == 20
    paged.page_number.should == 3
    paged.results.should == [21,22,23,24,25,26,27,28,29,30]
    paged = paginate(@collection, 20, 10)
    paged.results.size.should == 8
    paged.results.should == [191,192,193,194,195,196,197,198]
  end
  it "should populate page links" do
    paged = paginate(@collection, nil, nil)
    paged.populate_page_links { |n| "/foo?num=#{n}" }
    paged.links.size.should == 1
    paged.links.first.href.should == "/foo?num=2"
    paged.links.first.attr_pairs.should == [["rel","next"]]
  end
end

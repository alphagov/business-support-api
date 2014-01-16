require 'spec_helper'

describe PaginationPresenter do
  it "should initialize pagination values and paging links" do
    @schemes = [].tap do |ary|
      100.times { |n| ary << :"scheme#{n+1}" }
    end
    params = { :page_size => 25, :page_number => 2, :controller => 'business_support',
      :action => 'search', :format => :json }
    @request = stub(:headers => { 'HTTP_API_PREFIX' => 'api'},
                    :protocol => 'http', :host => 'www.gov.uk',
                    :optional_port => 80,
                    :symbolized_path_parameters => params)
    @context = BusinessSupportController.new
    @context.stub(:params).and_return(params)
    @context.stub(:request).and_return(@request)

    Plek.any_instance.stub(:website_root).and_return("http://www.gov.uk")
    presenter = PaginationPresenter.new(@schemes, @context)
    json_hash = presenter.as_json

    json_hash[:start_index].should == 26
    json_hash[:page_size].should == 25
    json_hash[:page_number.should] == 2
    json_hash[:total].should == 100
    json_hash[:pages].should == 4
    json_hash[:results].size.should == 25

    links = json_hash[:_response_info][:links]
    links.size.should == 2
    links.first.href.should == "http://www.gov.uk/api/business-support-schemes.json?page_number=3&page_size=25"
    links.last.href.should == "http://www.gov.uk/api/business-support-schemes.json?page_number=1&page_size=25"
  end
end

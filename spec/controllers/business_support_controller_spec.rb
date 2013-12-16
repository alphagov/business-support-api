require 'spec_helper'

describe BusinessSupportController do

  describe "GET search" do
    it "should set expiry headers" do
      get :search, :format => :json
      response.headers["Cache-Control"].should == "max-age=1800, public"
    end

    it "should accept json requests" do
      get :search, :format => :json
      response.should be_success
      response.header['Content-Type'].should include 'application/json'
    end

    it "should deny other formats" do
      get :search
      response.status.should == 406
    end
  end

  describe "GET show" do
    it "should set expiry headers" do
      get :show, :slug => "foo", :format => :json
      response.headers["Cache-Control"].should == "max-age=1800, public"
    end

    it "should accept json requests" do
      get :show, :slug => "bar", :format => :json
      response.should be_success
      response.header['Content-Type'].should include 'application/json'
    end

    it "should deny other formats" do
      get :show, :slug => "foo"
      response.status.should == 406
    end
  end
end

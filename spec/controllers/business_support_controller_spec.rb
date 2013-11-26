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
    end

    it "should deny other formats" do
      get :search
      response.code.should == "406"
    end
  end
end

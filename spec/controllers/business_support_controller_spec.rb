require 'rails_helper'

describe BusinessSupportController do

  describe "GET search" do
    it "should set expiry headers" do
      get :search, :format => :json
      expect(response.headers["Cache-Control"]).to eq("max-age=1800, public")
    end

    it "should accept json requests" do
      get :search, :format => :json
      expect(response).to be_success
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "should deny other formats" do
      get :search
      expect(response.status).to eq(406)
    end
  end

  describe "GET show" do
    it "should set expiry headers" do
      get :show, :slug => "foo", :format => :json
      expect(response.headers["Cache-Control"]).to eq("max-age=1800, public")
    end

    it "should accept json requests" do
      get :show, :slug => "bar", :format => :json
      expect(response).to be_success
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "should deny other formats" do
      get :show, :slug => "foo"
      expect(response.status).to eq(406)
    end
  end
end

require 'rails_helper'

describe BusinessSupportController do
  describe "GET search" do
    before do
      content_api_has_default_business_support_schemes
    end

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

    it "should set a deprecation warning header" do
      get :search, :format => :json
      expect(response.header['Warning']).to include '299'
    end
  end

  describe "GET show" do
    before do
      stub_content_api_default_artefact
      content_api_has_default_business_support_schemes
    end

    it "should set expiry headers" do
      get :show, :slug => "foo", :format => :json
      expect(response.headers["Cache-Control"]).to eq("max-age=1800, public")
    end

    it "should accept json requests" do
      get :show, :slug => "foo", :format => :json
      expect(response).to be_success
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "should deny other formats" do
      get :show, :slug => "foo"
      expect(response.status).to eq(406)
    end

    it "should set a deprecation warning header" do
      get :show, :slug => "foo", :format => :json
      expect(response.header['Warning']).to include '299'
    end

    it "should 404 if the slug is not a business support scheme" do
      content_api_does_not_have_an_artefact('bar')
      get :show, :slug => "bar", format: :json
      expect(response.status).to eq(404)
    end

    it "should 410 if the slug is a withdrawn business support scheme" do
      content_api_has_an_archived_artefact('bar')
      get :show, :slug => "bar", format: :json
      expect(response.status).to eq(410)
    end
  end
end

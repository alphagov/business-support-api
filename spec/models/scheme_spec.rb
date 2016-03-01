require 'spec_helper'

describe Scheme do
  describe "looking up schemes" do
    before :each do
      @sector = 'health'
      @stage = 'start-up'
      @size = 'under-10'
      @support_types = %w(finance loan)
      @location = 'wales'

      allow_any_instance_of(GdsApi::ContentApi).to receive(:business_support_schemes)
        .and_return("results" => [])
    end

    after :each do
      # Necessary to prevent stack level too deep errors caused by objects with
      # stubs applied being persisted between requests.
      Scheme.instance_variable_set('@content_api', nil)
    end

    it "should fetch the schemes from content_api" do
      expect_any_instance_of(GdsApi::ContentApi).to receive(:business_support_schemes)
        .with(
          :sectors => @sector,
          :stages => @stage,
          :business_sizes => @size,
          :support_types => @support_types,
          :locations => @location,
        )
        .and_return("results" => [])

      Scheme.lookup(
        :sectors => @sector,
        :stages => @stage,
        :business_sizes => @size,
        :support_types => @support_types,
        :locations => @location,
      )
    end

    it "should construct instances of Scheme for each result and return them" do
      facets = {
        'business_sizes' => [],
        'locations' => ['england'],
        'sectors' => ['manufacturing'],
        'stages' => [],
        'support_types' => ['grant'],
      }

      artefact1 = {'identifier' => '666', 'title' => 'artefact1'}.merge(facets)
      artefact2 = {'identifier' => '999', 'title' => 'artefact2'}.merge(facets)

      allow_any_instance_of(GdsApi::ContentApi).to receive(:business_support_schemes)
        .and_return("results" => [artefact1, artefact2])

      expect(Scheme).to receive(:new).with(artefact1).and_return(:scheme1)
      expect(Scheme).to receive(:new).with(artefact2).and_return(:scheme2)

      schemes = Scheme.lookup(
        :sectors => @sector,
        :stage => @stage,
        :size => @size,
        :support_types => @support_types,
        :locations => @location,
      )
      expect(schemes).to eq([:scheme1, :scheme2])
    end

    describe "lookup" do
      before do
        artefact1 = {"identifier" => "1", "title" => "artefact1"}
        artefact2 = {"identifier" => "2", "title" => "artefact2"}
        artefact3 = {"identifier" => "3", "title" => "artefact3"}
        artefact4 = {"identifier" => "4", "title" => "artefact4"}

        allow_any_instance_of(GdsApi::ContentApi).to receive(:business_support_schemes)
          .and_return("results" => [artefact4, artefact1, artefact3, artefact2])

        expect(Scheme).to receive(:new).with(artefact1).and_return(:scheme1)
        expect(Scheme).to receive(:new).with(artefact2).and_return(:scheme2)
        expect(Scheme).to receive(:new).with(artefact3).and_return(:scheme3)
        expect(Scheme).to receive(:new).with(artefact4).and_return(:scheme4)
      end

      it "should order the schemes by contentapi result order" do
        schemes = Scheme.lookup(
          :sectors => @sector,
          :stage => @stage,
          :size => @size,
          :support_types => @support_types,
          :location => @location,
        )
        expect(schemes).to eq([:scheme4, :scheme1, :scheme3, :scheme2])
      end
    end
  end

  describe "constructing from content_api artefact hash" do
    it "should assign all top-level fields to the openstruct" do
      s = Scheme.new(
        "foo" => "bar",
        "something_else" => "wibble",
        "details" => {
          "foo" => "foo",
          "bar" => "bar",
        },
      )

      expect(s.foo).to eq("bar")
      expect(s.something_else).to eq("wibble")
      expect(s.details).to eq({ "foo" => "foo", "bar" => "bar" })
    end
  end

  describe "area codes returned from imminence" do
    it "should only use whitelisted area types" do
      area1 = {
        "slug" => "north-east",
        "name" => "North East",
        "country_name" => "England",
        "type" => "LAC",
        "codes" => {
          "gss" => "E32000012",
        },
      }
      area2 = {
        "slug" => "european-parliament",
        "name" => "European Parliament",
        "country_name" => "-",
        "type" => "EUP",
        "codes" => {
          "gss" => nil,
        },
      }
      area3 = {
        "slug" => "london",
        "name" => "London",
        "country_name" => "England",
        "type" => "EUR",
        "codes" => {
          "gss" => "E15000007",
        },
      }

      allow_any_instance_of(GdsApi::Imminence).to receive(:areas_for_postcode)
        .and_return("results" => [area1,area2,area3])

      expect(Scheme.area_identifiers("E5 9LR")).to eq("E15000007")
    end
  end
end

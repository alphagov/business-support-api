require 'ostruct'
require 'gds_api/helpers'

class Scheme < OpenStruct
  extend GdsApi::Helpers

  FACET_KEYS = [:areas, :business_sizes, :locations, :sectors, :stages, :support_types]

  def self.lookup(params={})

    postcode = params.delete(:postcode)
    params[:areas] = area_identifiers(postcode) if postcode

    response = content_api.business_support_schemes(params)

    response["results"].map do |s|
      self.new(s)
    end
  end

  def self.find_by_slug(slug)
    Scheme.new(content_api.artefact(slug).to_hash)
  end

  def initialize(artefact = {})
    super()
    artefact.each do |k,v|
      self.send("#{k}=", v)
    end
  end

  def as_json(options={})
    self.marshal_dump
  end

  def self.area_identifiers(postcode)
    areas_response = imminence_api.areas_for_postcode(postcode)
    areas = areas_response["results"].map { |area| area["slug"] }
    areas.join(",")
  end
end

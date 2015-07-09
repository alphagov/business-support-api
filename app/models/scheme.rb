require 'ostruct'
require 'gds_api/helpers'

class Scheme < OpenStruct
  extend GdsApi::Helpers

  FACET_KEYS = [:areas, :business_sizes, :locations, :sectors, :stages, :support_types]
  # This list should stay in sync with Publisher's AREA_TYPES list
  # (https://github.com/alphagov/publisher/blob/master/app/models/area.rb#L7).
  WHITELISTED_AREA_CODES = ["EUR", "CTY", "DIS", "LBO", "LGD", "MTD", "UTA"]

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
    return [] unless areas_response

    areas = areas_response["results"].map do |area|
      area["slug"] if WHITELISTED_AREA_CODES.include?(area["type"])
    end
    areas.reject(&:blank?).join(",")
  end
end

require 'ostruct'
require 'gds_api/helpers'

class Scheme < OpenStruct
  extend GdsApi::Helpers

  RecordNotFound = Class.new(StandardError)
  RecordGone = Class.new(StandardError)

  FACET_KEYS = [
    :area_gss_codes,
    :business_sizes,
    :locations,
    :sectors,
    :stages,
    :support_types,
  ]

  # This list should stay in sync with Publisher's Area::AREA_TYPES list:
  # https://github.com/alphagov/publisher/blob/master/app/models/area.rb#L7-L10
  # and Imminences areas route constraint:
  # https://github.com/alphagov/imminence/blob/master/config/routes.rb#L13-L17
  WHITELISTED_AREA_CODES = ["EUR", "CTY", "DIS", "LBO", "LGD", "MTD", "UTA", "COI"]

  def self.lookup(params={})
    postcode = params.delete(:postcode)
    params[:area_gss_codes] = area_identifiers(postcode) if postcode
  begin
    response = content_api.business_support_schemes(params)
  rescue GdsApi::HTTPNotFound
    raise RecordNotFound
  rescue GdsApi::HTTPGone
    raise RecordGone
  end
    response["results"].map { |s| self.new(s) }
  end

  def self.find_by_slug(slug)
    artefact = content_api.artefact!(slug)
    Scheme.new(artefact.to_hash)
  rescue GdsApi::HTTPNotFound
    raise RecordNotFound, slug
  rescue GdsApi::HTTPGone
    raise RecordGone, slug
  end

  def as_json(options={})
    self.marshal_dump
  end

  def self.area_identifiers(postcode)
  begin
    areas_response = imminence_api.areas_for_postcode(postcode)
  rescue GdsApi::HTTPNotFound, GdsApi::HTTPGone
    []
  end
    areas = areas_response["results"].map do |area|
      area["codes"]["gss"] if WHITELISTED_AREA_CODES.include?(area["type"])
    end
    areas.reject(&:blank?).join(",")
  end
end

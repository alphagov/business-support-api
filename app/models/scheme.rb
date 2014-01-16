require 'ostruct'
require 'gds_api/helpers'

class Scheme < OpenStruct
  extend GdsApi::Helpers

  FACET_KEYS = [:business_sizes, :locations, :sectors, :stages, :support_types]

  def self.lookup(params={})
    possible_schemes = imminence_api.business_support_schemes(params)
    return [] if possible_schemes["results"].empty?

    imminence_data = map_schemes_by_identifier(possible_schemes)
    schemes = content_api.business_support_schemes(imminence_data.keys)

    schemes["results"].sort_by { |s| imminence_data.keys.index(s["identifier"]) }.map do |s|
      s = s.merge(imminence_facets_for_scheme(imminence_data, s))
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

  private

  def self.map_schemes_by_identifier(schemes)
    ohash = ActiveSupport::OrderedHash.new
    schemes["results"].map do |s|
      ohash[s["business_support_identifier"]] = s
    end
    ohash
  end

  def self.imminence_facets_for_scheme(imminence_data, scheme)
    imminence_data_for_scheme = imminence_data[scheme["identifier"]]
    facets = {}
    FACET_KEYS.each do |k|
      facets[k.to_s] = imminence_data_for_scheme[k.to_s] || []
    end
    facets
  end
end

require 'ostruct'
require 'gds_api/helpers'
require 'pagination'

class Scheme < OpenStruct
  extend GdsApi::Helpers
  extend Pagination

  FACET_KEYS = [:business_sizes, :locations, :sectors, :stages, :support_types]

  def self.lookup(params={})
    possible_schemes = imminence_api.business_support_schemes(params)
    return paginate([], nil, nil) if possible_schemes["results"].empty?

    imminence_data = map_schemes_by_identifier(possible_schemes)
    schemes = content_api.business_support_schemes(imminence_data.keys)

    schemes = schemes["results"].sort_by { |s| imminence_data.keys.index(s["identifier"]) }.map do |s|
      s = s.merge(imminence_facets_for_scheme(imminence_data, s))
      self.new(s)
    end

    paginate(schemes, params[:page_number], params[:page_size])
  end

  def initialize(artefact = {})
    super()
    if (details = artefact.delete("details"))
      details.each do |k,v|
        self.send("#{k}=", v)
      end
    end
    artefact.each do |k,v|
      self.send("#{k}=", v)
    end
  end

  def as_json(options={})
    attrs = self.marshal_dump
    valid_keys = [:identifier, :title, :priority] + FACET_KEYS
    attrs.select { |k,v| valid_keys.include?(k.to_sym) }
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

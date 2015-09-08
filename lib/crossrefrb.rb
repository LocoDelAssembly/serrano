require 'httparty'
require 'json'
require "crossrefrb/version"
require "crossrefrb/request"

##
# Crossref - The top level module for using methods
# to access Crossref APIs
#
# The following methods are available:
# * works - Use the /works endpoint
# * members - use the /members endpoint
module Crossref
  ##
  # Search the works API
  #
  # @param doi [Array] A DOI, digital object identifier
  # @param query [String] A query string
  # @return [Array] the output
  #
  # @example
  #     require 'crossrefrb'
  #     # Search by DOI, one or more
  #     Crossref.works(doi: '10.5555/515151')
  #     Crossref.works(doi: '10.1371/journal.pone.0033693')
  #     Crossref.works(doi: ['10.1007/12080.1874-1746','10.1007/10452.1573-5125', '10.1111/(issn)1442-9993'])
  #     # query
  #     Crossref.works(query: "ecology")
  #     Crossref.works(query: "renear+-ontologies")
  #     # Sort
  #     Crossref.works(query: "ecology", sort: 'relevance', order: "asc")
  def self.works(doi: nil, query: nil, filter: nil, offset: nil,
    limit: nil, sample: nil, sort: nil, order: nil, facet: nil)

    Request.new('works', doi, query, filter, offset,
      limit, sample, sort, order, facet).perform
  end

  ##
  # Search the members API
  #
  # @param ids [Array] A member id, or more than one
  # @param query [String] A query string
  # @return [Array] the output
  #
  # @example
  #     require 'crossrefrb'
  #     # Search by DOI, one or more
  #     Crossref.members(ids: 98)
  #     Crossref.members(ids: 340)
  #     Crossref.members(ids: [98, 340, 45])
  #     # query
  #     Crossref.members(query: "ecology")
  #     # Sort
  #     Crossref.members(query: "ecology", sort: 'relevance', order: "asc")
  def self.members(ids: nil, query: nil, filter: nil, offset: nil,
    limit: nil, sample: nil, sort: nil, order: nil, facet: nil)

    Request.new('members', ids, query, filter, offset,
      limit, sample, sort, order, facet).perform
  end
end

require "serrano/version"
require "serrano/request"
require "serrano/filterhandler"
require "serrano/cnrequest"

# @!macro serrano_params
#   @param ids [Array] DOIs (digital object identifier) or other identifiers
#   @param offset [Fixnum] Number of record to start at, from 1 to infinity.
#   @param limit [Fixnum] Number of results to return. Not relavant when searching with specific dois. Default: 20. Max: 1000
#   @param sample [Fixnum] Number of random results to return. when you use the sample parameter,
#   the limit and offset parameters are ignored.
#   @param sort [String] Field to sort on, one of score, relevance,
#   updated (date of most recent change to metadata. Currently the same as deposited),
#   deposited (time of most recent deposit), indexed (time of most recent index), or
#   published (publication date). Note: If the API call includes a query, then the sort
#   order will be by the relevance score. If no query is included, then the sort order
#   will be by DOI update date.
#   @param order [String] Sort order, one of 'asc' or 'desc'
#   @param facet [Boolean] Include facet results. Default: false

##
# Serrano - The top level module for using methods
# to access Serrano APIs
#
# The following methods, matching the main Crossref API routes, are available:
# * works - Use the /works endpoint
# * members - Use the /members endpoint
# * prefixes - Use the /prefixes endpoint
# * funders - Use the /funders endpoint
# * journals - Use the /journals endpoint
# * types - Use the /types endpoint
# * licenses - Use the /licenses endpoint
#
# Additional methods
# * agency - test the registration agency for a DOI
#
# All routes return an array of hashes
# For example, if you want to inspect headers returned from the HTTP request,
# and parse the raw result in any way you wish.
#
# @see https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md for
# detailed description of the Crossref API
module Serrano
  extend Configuration

  define_setting :access_token
  define_setting :access_secret
  define_setting :base_url, "http://api.crossref.org/"

  ##
  # Search the works route
  #
  # @!macro serrano_params
  # @param query [String] A query string
  # @param filter [Hash] Filter options. See ...
  # @return [Array] An array of hashes
  #
  # @example
  #      require 'serrano'
  #      # Search by DOI, one or more
  #      Serrano.works(ids: '10.5555/515151')
  #      Serrano.works(ids: '10.1371/journal.pone.0033693')
  #      Serrano.works(ids: ['10.1007/12080.1874-1746','10.1007/10452.1573-5125', '10.1111/(issn)1442-9993'])
  #      # query
  #      Serrano.works(query: "ecology")
  #      Serrano.works(query: "renear+-ontologies")
  #      # Sort
  #      Serrano.works(query: "ecology", sort: 'relevance', order: "asc")
  #      # Filters
  #      Serrano.works(filter: {has_full_text: true})
  #      Serrano.works(filter: {has_funder: true, has_full_text: true})
  #      Serrano.works(filter: {award_number: 'CBET-0756451', award_funder: '10.13039/100000001'})
  #      # Curl options
  #      Serrano.works(ids: '10.1371/journal.pone.0033693', options: {request.timeout: 3})
  def self.works(ids: nil, query: nil, filter: nil, offset: nil,
    limit: nil, sample: nil, sort: nil, order: nil, facet: nil)

    Request.new('works', ids, query, filter, offset,
      limit, sample, sort, order, facet, nil, nil).perform
  end

  ##
  # Search the members route
  #
  # @!macro serrano_params
  # @param query [String] A query string
  # @param filter [Hash] Filter options. See ...
  # @param works [Boolean] If true, works returned as well. Default: false
  # @return [Array] An array of hashes
  #
  # @example
  #      require 'serrano'
  #      # Search by DOI, one or more
  #      Serrano.members(ids: 98)
  #      Serrano.members(ids: 340)
  #      Serrano.members(ids: [98, 340, 45])
  #      # query
  #      Serrano.members(query: "ecology")
  #      Serrano.members(query: "hindawi")
  #      # Sort - weird, doesn't work
  #      Serrano.members(query: "ecology", order: "asc")
  #      # Works
  #      Serrano.members(ids: 98, works: true)
  def self.members(ids: nil, query: nil, filter: nil, offset: nil,
    limit: nil, sample: nil, sort: nil, order: nil, facet: nil, works: false)

    Request.new('members', ids, query, filter, offset,
      limit, sample, sort, order, facet, works, nil).perform
  end

  ##
  # Search the prefixes route
  #
  # @!macro serrano_params
  # @param filter [Hash] Filter options. See ...
  # @param works [Boolean] If true, works returned as well. Default: false
  # @return [Array] An array of hashes
  #
  # @example
  #      require 'serrano'
  #      # Search by DOI, one or more
  #      Serrano.prefixes(ids: "10.1016")
  #      Serrano.prefixes(ids: ['10.1016','10.1371','10.1023','10.4176','10.1093'])
  #      # works
  #      Serrano.prefixes(ids: "10.1016", works: true)
  #      # Limit number of results
  #      Serrano.prefixes(ids: "10.1016", works: true, limit: 3)
  #      # Sort and order
  #      Serrano.prefixes(ids: "10.1016", works: true, sort: 'relevance', order: "asc")
  def self.prefixes(ids:, filter: nil, offset: nil,
    limit: nil, sample: nil, sort: nil, order: nil, facet: nil, works: false)

    Request.new('prefixes', ids, nil, filter, offset,
      limit, sample, sort, order, facet, works, nil).perform
  end

  ##
  # Search the funders route
  #
  # @!macro serrano_params
  # @param query [String] A query string
  # @param filter [Hash] Filter options. See ...
  # @param works [Boolean] If true, works returned as well. Default: false
  # @return [Array] An array of hashes
  #
  # @example
  #      require 'serrano'
  #      # Search by DOI, one or more
  #      Serrano.funders(ids: '10.13039/100000001')
  #      Serrano.funders(ids: ['10.13039/100000001','10.13039/100000015'])
  #      # query
  #      Serrano.funders(query: "NSF")
  #      # works
  #      Serrano.funders(ids: '10.13039/100000001', works: true)
  #      # Limit number of results
  #      Serrano.funders(ids: '10.13039/100000001', works: true, limit: 3)
  #      # Sort and order
  #      Serrano.funders(ids: "10.13039/100000001", works: true, sort: 'relevance', order: "asc")
  def self.funders(ids: nil, query: nil, filter: nil, offset: nil,
    limit: nil, sample: nil, sort: nil, order: nil, facet: nil, works: false)

    Request.new('funders', ids, query, filter, offset,
      limit, sample, sort, order, facet, works, nil).perform
  end

  ##
  # Search the journals route
  #
  # @!macro serrano_params
  # @param query [String] A query string
  # @param filter [Hash] Filter options. See ...
  # @param works [Boolean] If true, works returned as well. Default: false
  # @return [Array] An array of hashes
  #
  # @example
  #      require 'serrano'
  #      Serrano.journals(ids: "2167-8359")
  #      Serrano.journals()
  #      Serrano.journals(ids: "2167-8359", works: true)
  #      Serrano.journals(ids: ['1803-2427', '2326-4225'])
  #      Serrano.journals(query: "ecology")
  #      Serrano.journals(query: "peerj")
  #      Serrano.journals(ids: "2167-8359", query: 'ecology', works: true, sort: 'score', order: "asc")
  #      Serrano.journals(ids: "2167-8359", query: 'ecology', works: true, sort: 'score', order: "desc")
  #      Serrano.journals(ids: "2167-8359", works: true, filter: {from_pub_date: '2014-03-03'})
  #      Serrano.journals(ids: '1803-2427', works: true)
  #      Serrano.journals(ids: '1803-2427', works: true)
  #      Serrano.journals(limit: 2)
  #      Serrano.journals(sample: 2)
  def self.journals(ids: nil, query: nil, filter: nil, offset: nil,
    limit: nil, sample: nil, sort: nil, order: nil, facet: nil, works: false)

    Request.new('journals', ids, query, filter, offset,
      limit, sample, sort, order, facet, works, nil).perform
  end

  ##
  # Search the types route
  #
  # @param ids [Array] DOIs (digital object identifier) or other identifiers
  # @param works [Boolean] If true, works returned as well. Default: false
  # @return [Array] An array of hashes
  #
  # @example
  #      require 'serrano'
  #      Serrano.types()
  #      Serrano.types(ids: "journal")
  #      Serrano.types(ids: ["journal", "dissertation"])
  #      Serrano.types(ids: "journal", works: true)
  def self.types(ids: nil, works: false)

    Request.new('types', ids, nil, nil, nil,
      nil, nil, nil, nil, nil, works, nil).perform
  end

  ##
  # Search the licenses route
  #
  # @!macro serrano_params
  # @param query [String] A query string
  # @return [Array] An array of hashes
  #
  # @example
  #      require 'serrano'
  #      Serrano.licenses(query: "creative")
  #      Serrano.licenses()
  #      Serrano.licenses(limit: 3)
  def self.licenses(ids: nil, query: nil, offset: nil,
    limit: nil, sample: nil, sort: nil, order: nil, facet: nil)

    Request.new('licenses', ids, query, nil, offset,
      limit, sample, sort, order, facet, nil, nil).perform
  end

  ##
  # Determine registration agency for DOIs
  #
  # @param ids [Array] DOIs (digital object identifier) or other identifiers
  # @return [Array] An array of hashes
  #
  # @example
  #      require 'serrano'
  #      Serrano.agency(ids: '10.1371/journal.pone.0033693')
  #      Serrano.agency(ids: ['10.1007/12080.1874-1746','10.1007/10452.1573-5125', '10.1111/(issn)1442-9993'])
  def self.agency(ids:)

    Request.new('works', ids, nil, nil, nil,
      nil, nil, nil, nil, nil, false, true).perform
  end

  ##
  # Get a random set of DOI's
  #
  # @param sample [Fixnum] Number of random DOIs to return
  # @return [Array] A list of strings, each a DOI
  # @note This method uses {Serrano.works} internally, but doesn't allow you to pass on
  # arguments to that method.
  #
  # @example
  #      require 'serrano'
  #      Serrano.random_dois(sample: 1)
  #      Serrano.random_dois(sample: 10)
  #      Serrano.random_dois(sample: 100)
  def self.random_dois(sample:)

    tmp = Request.new('works', nil, nil, nil, nil,
      nil, sample, nil, nil, nil, false, nil).perform
    tmp['message']['items'].collect { |x| x['DOI'] }
  end

  ##
  # Get citations in various formats from CrossRef
  #
  # @param ids [String] DOIs
  # @param format [String] Format
  # @param style [String] Style
  # @param locale [String] Locale
  # @return [Hash] A hash
  #
  # @example
  #     require 'serrano'
  #     # By default, you get bibtex, apa format, in en-US locale
  #     Serrano.cn(ids: '10.1126/science.169.3946.635')
  #
  #     # get citeproc-json
  #     Serrano.cn(ids: '10.1126/science.169.3946.635', format: "citeproc-json")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "citeproc-json")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "rdf-xml")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "crossref-xml")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "text")
  #
  #     # return an R bibentry type
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "bibentry")
  #     Serrano.cn(ids: "10.6084/m9.figshare.97218", format: "bibentry")
  #
  #     # return an apa style citation
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "text", style: "apa")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "text", style: "harvard3")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "text", style: "elsevier-harvard")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "text", style: "ecoscience")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "text", style: "heredity")
  #     Serrano.cn(ids: "10.1126/science.169.3946.635", format: "text", style: "oikos")
  #
  #     # example with many DOIs
  #     dois <- cr_r(2)
  #     Serrano.cn(dois, format: "text", style: "apa")
  #
  #     # Using DataCite DOIs
  #     ## some formats don't work
  #     # Serrano.cn(ids: "10.5284/1011335", format: "text")
  #     # Serrano.cn(ids: "10.5284/1011335", format: "crossref-xml")
  #     # Serrano.cn(ids: "10.5284/1011335", format: "crossref-tdm")
  #
  #     ## But most do work
  #     Serrano.cn(ids: "10.5284/1011335", format: "datacite-xml")
  #     Serrano.cn(ids: "10.5284/1011335", format: "rdf-xml")
  #     Serrano.cn(ids: "10.5284/1011335", format: "turtle")
  #     Serrano.cn(ids: "10.5284/1011335", format: "citeproc-json")
  #     Serrano.cn(ids: "10.5284/1011335", format: "ris")
  #     Serrano.cn(ids: "10.5284/1011335", format: "bibtex")
  #     Serrano.cn(ids: "10.5284/1011335", format: "bibentry")
  #     Serrano.cn(ids: "10.5284/1011335", format: "bibtex")
  #
  #     # many DOIs
  #     dois = ['10.5167/UZH-30455','10.5167/UZH-49216','10.5167/UZH-503', '10.5167/UZH-38402','10.5167/UZH-41217']
  #     x = Serrano.cn(ids: dois)
  #     puts x
  def self.cn(ids:, format: "bibtex", style: 'apa', locale: "en-US")
    CNRequest.new(ids, format, style, locale).perform
  end

end

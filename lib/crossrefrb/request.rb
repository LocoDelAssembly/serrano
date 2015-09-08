require 'httparty'

##
# Crossref::Request
#
# Class to perform HTTP requests to the Crossref API
module Crossref
  class Request #:nodoc:
    $crbase = "http://api.crossref.org/"

    attr_accessor :endpt
    attr_accessor :doi
    attr_accessor :query
    attr_accessor :filter
    attr_accessor :offset
    attr_accessor :limit
    attr_accessor :sample
    attr_accessor :sort
    attr_accessor :order
    attr_accessor :facet

    def initialize(endpt, doi, query, filter, offset,
      limit, sample, sort, order, facet)

      self.endpt = endpt
      self.doi = doi
      self.query = query
      self.filter = filter
      self.offset = offset
      self.limit = limit
      self.sample = sample
      self.sort = sort
      self.order = order
      self.facet = facet
    end

    def perform
      url = $crbase + self.endpt

      args = { query: self.query, filter: self.filter, offset: self.offset,
              rows: self.limit, sample: self.sample, sort: self.sort,
              order: self.order, facet: self.facet }
      options = { query: args.delete_if { |k, v| v.nil? } }

      if self.doi.nil?
        res = HTTParty.get(url, options)
        return res
      else
        coll = []
        Array(self.doi).each do |x|
          coll << HTTParty.get(url + '/' + x)
        end
        return coll
      end
    end
  end
end

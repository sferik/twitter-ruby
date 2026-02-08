require "twitter/enumerable"
require "twitter/utils"

module Twitter
  # Represents a collection of geo search results
  class GeoResults
    include Enumerable
    include Utils

    # The raw attributes hash
    #
    # @api public
    # @example
    #   results.attrs
    # @return [Hash]
    attr_reader :attrs

    # @!method to_h
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_h
    #   @return [Hash]
    alias_method :to_h, :attrs

    # @!method to_hash
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_hash
    #   @return [Hash]
    alias_method :to_hash, :to_h

    # Initializes a new GeoResults object
    #
    # @api public
    # @example
    #   Twitter::GeoResults.new(result: {places: []})
    # @param attrs [Hash] The attributes hash from the API response
    # @return [Twitter::GeoResults]
    def initialize(attrs = nil)
      @attrs = attrs || {}
      empty_hash = {} # : Hash[Symbol, untyped]
      empty_array = [] # : Array[untyped]
      @collection = @attrs.fetch(:result, empty_hash).fetch(:places, empty_array).collect do |place| # steep:ignore ArgumentTypeMismatch
        Place.new(place)
      end
    end

    # Returns the token for pagination
    #
    # @api public
    # @example
    #   results.token
    # @return [String]
    def token
      @attrs[:token]
    end
  end
end

require "twitter/enumerable"
require "twitter/utils"

module Twitter
  # Represents a collection of geo search results
  class GeoResults
    include Twitter::Enumerable
    include Twitter::Utils

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
    alias to_h attrs

    # @!method to_hash
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_hash
    #   @return [Hash]
    alias to_hash to_h

    # Initializes a new GeoResults object
    #
    # @api public
    # @example
    #   Twitter::GeoResults.new(result: {places: []})
    # @param attrs [Hash] The attributes hash from the API response
    # @return [Twitter::GeoResults]
    def initialize(attrs = {})
      @attrs = attrs
      @collection = @attrs[:result].fetch(:places, []).collect do |place|
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

require "memoizable"
require "twitter/identity"

module Twitter
  # Represents a Twitter place
  class Place < Twitter::Identity
    include Memoizable

    # The place attributes hash
    #
    # @api public
    # @example
    #   place.attributes
    # @return [Hash]
    attr_reader :attributes

    # The country name
    #
    # @api public
    # @example
    #   place.country
    # @return [String]

    # The full name of the place
    #
    # @api public
    # @example
    #   place.full_name
    # @return [String]

    # The place name
    #
    # @api public
    # @example
    #   place.name
    # @return [String]
    attr_reader :country, :full_name, :name

    # The Where On Earth ID
    #
    # @!method woe_id
    # @api public
    # @example
    #   place.woe_id
    # @return [Integer]
    alias woe_id id

    # The Where On Earth ID
    #
    # @!method woeid
    # @api public
    # @example
    #   place.woeid
    # @return [Integer]
    alias woeid id
    object_attr_reader :GeoFactory, :bounding_box
    object_attr_reader :Place, :contained_within

    # Returns true if this place is contained within another
    #
    # @!method contained?
    # @api public
    # @example
    #   place.contained?
    # @return [Boolean]
    alias contained? contained_within?
    uri_attr_reader :uri

    # Initializes a new place
    #
    # @api public
    # @example
    #   Twitter::Place.new(woeid: 12345)
    # @param attrs [Hash] The attributes hash
    # @raise [ArgumentError] Error raised when argument is missing a :woeid key
    # @return [Twitter::Place]
    def initialize(attrs = {})
      attrs[:id] ||= attrs.fetch(:woeid)
      super
    end

    # Returns the country code
    #
    # @api public
    # @example
    #   place.country_code
    # @return [String]
    def country_code
      @attrs[:country_code] || @attrs[:countryCode]
    end
    memoize :country_code

    # Returns the parent place ID
    #
    # @api public
    # @example
    #   place.parent_id
    # @return [Integer]
    def parent_id
      @attrs[:parentid]
    end
    memoize :parent_id

    # Returns the place type
    #
    # @api public
    # @example
    #   place.place_type
    # @return [String]
    def place_type
      @attrs[:place_type] || (@attrs[:placeType] && @attrs[:placeType][:name])
    end
    memoize :place_type
  end
end

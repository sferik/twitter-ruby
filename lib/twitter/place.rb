require 'equalizer'
require 'twitter/identity'

module Twitter
  class Place < Twitter::Identity
    # @return [Hash]
    attr_reader :attributes
    # @return [String]
    attr_reader :country, :full_name, :name
    alias_method :woe_id, :id
    alias_method :woeid, :id
    object_attr_reader :GeoFactory, :bounding_box
    object_attr_reader :Place, :contained_within
    alias_method :contained?, :contained_within?
    uri_attr_reader :uri

    # @return [String]
    def country_code
      @attrs[:country_code] || @attrs[:countryCode] # rubocop:disable SymbolName
    end
    memoize :country_code

    # @return [Integer]
    def parent_id
      @attrs[:parentid]
    end
    memoize :parent_id

    # @return [String]
    def place_type
      @attrs[:place_type] || @attrs[:placeType] && @attrs[:placeType][:name] # rubocop:disable SymbolName
    end
    memoize :place_type
  end
end

require 'equalizer'
require 'twitter/base'

module Twitter
  class Place < Twitter::Base
    include Equalizer.new(:woeid)
    attr_reader :attributes, :country, :full_name, :name, :woeid
    alias woe_id woeid
    object_attr_reader :GeoFactory, :bounding_box
    object_attr_reader :Place, :contained_within
    alias contained? contained_within?
    uri_attr_reader :uri

    # @return [String]
    def country_code
      @attrs[:country_code] || @attrs[:countryCode]
    end
    memoize :country_code

    # @return [Integer]
    def parent_id
      @attrs[:parentid]
    end
    memoize :parent_id

    # @return [String]
    def place_type
      @attrs[:place_type] || @attrs[:placeType] && @attrs[:placeType][:name]
    end
    memoize :place_type

  end
end

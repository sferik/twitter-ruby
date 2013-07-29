require 'twitter/identity'

module Twitter
  class Place < Twitter::Identity
    attr_reader :attributes, :country, :full_name, :name, :woeid
    alias woe_id woeid
    object_attr_reader :GeoFactory, :bounding_box
    object_attr_reader :Place, :contained_within
    alias contained? contained_within?
    uri_attr_reader :uri

    # @return [String]
    def country_code
      memoize(:country_code) do
        @attrs[:country_code] || @attrs[:countryCode]
      end
    end

    # @return [Integer]
    def parent_id
      memoize(:parent_id) do
        @attrs[:parentid]
      end
    end

    # @return [String]
    def place_type
      memoize(:place_type) do
        @attrs[:place_type] || @attrs[:placeType] && @attrs[:placeType][:name]
      end
    end

    # return [Integer]
    def id
      @attrs[:id] || @attrs[:woeid]
    end

  end
end

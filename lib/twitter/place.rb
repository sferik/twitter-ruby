require 'twitter/identity'

module Twitter
  class Place < Twitter::Identity
    attr_reader :attributes, :country, :full_name, :name, :url, :woeid
    alias uri url
    alias woe_id woeid
    object_attr_reader :GeoFactory, :bounding_box
    object_attr_reader :Place, :contained_within
    alias contained? contained_within?

    # @return [String]
    def country_code
      @country_code ||= @attrs[:country_code] || @attrs[:countryCode]
    end

    # @return [Integer]
    def parent_id
      @parent_id ||= @attrs[:parentid]
    end

    # @return [String]
    def place_type
      @place_type ||= @attrs[:place_type] || @attrs[:placeType] && @attrs[:placeType][:name]
    end

    def id
      @attrs[:id] || @attrs[:woeid]
    end

  end
end

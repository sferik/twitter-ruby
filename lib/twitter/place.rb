require 'twitter/identity'

module Twitter
  class Place < Twitter::Identity
    attr_reader :attributes, :country, :full_name, :name, :url, :woeid
    alias woe_id woeid

    # @return [Twitter::Geo]
    def bounding_box
      @bounding_box ||= Twitter::GeoFactory.fetch_or_new(@attrs[:bounding_box])
    end

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

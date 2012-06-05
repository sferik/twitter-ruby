require 'twitter/geo_factory'
require 'twitter/identifiable'

module Twitter
  class Place < Twitter::Identifiable
        attr_reader :attributes, :country, :full_name, :name, :url, :woeid
    alias :woe_id :woeid

    # @param other [Twitter::Place]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @return [Twitter::Point, Twitter::Polygon]
    def bounding_box
      @bounding_box ||= Twitter::GeoFactory.new(@attrs['bounding_box']) unless @attrs['bounding_box'].nil?
    end

    # @return [String]
    def country_code
      @country_code ||= @attrs['country_code'] || @attrs['countryCode']
    end

    # @return [Integer]
    def parent_id
      @parent_id ||= @attrs['parentid']
    end

    # @return [String]
    def place_type
      @place_type ||= @attrs['place_type'] || @attrs['placeType'] && @attrs['placeType']['name']
    end

  end
end

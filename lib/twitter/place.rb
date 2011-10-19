require 'twitter/base'
require 'twitter/geo_factory'

module Twitter
  class Place < Twitter::Base
    lazy_attr_reader :attributes, :country, :full_name, :id, :name, :url,
      :woeid

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def bounding_box
      @bounding_box ||= Twitter::GeoFactory.new(@attrs['bounding_box']) unless @attrs['bounding_box'].nil?
    end

    def country_code
      @country_code ||= @attrs['country_code'] || @attrs['countryCode']
    end

    def parent_id
      @parent_id ||= @attrs['parentid']
    end

    def place_type
      @place_type ||= @attrs['place_type'] || @attrs['placeType'] && @attrs['placeType']['name']
    end

  end
end

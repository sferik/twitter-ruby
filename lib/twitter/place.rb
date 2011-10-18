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
      @bounding_box ||= Twitter::GeoFactory.new(@attributes['bounding_box']) unless @attributes['bounding_box'].nil?
    end

    def country_code
      @country_code ||= @attributes['country_code'] || @attributes['countryCode']
    end

    def parent_id
      @parent_id ||= @attributes['parentid']
    end

    def place_type
      @place_type ||= @attributes['place_type'] || @attributes['placeType'] && @attributes['placeType']['name']
    end

  end
end

require 'twitter/base'
require 'twitter/geo_factory'

module Twitter
  class Place < Twitter::Base
    attr_reader :attributes, :bounding_box, :country, :country_code,
      :full_name, :id, :name, :place_type, :parent_id, :url, :woeid

    def initialize(place={})
      @attributes = place['attributes']
      @bounding_box = Twitter::GeoFactory.new(place['bounding_box']) unless place['bounding_box'].nil?
      @country = place['country']
      @country_code = place['country_code'] || place['countryCode']
      @full_name = place['full_name']
      @id = place['id']
      @name = place['name']
      @parent_id = place['parentid']
      @place_type = place['place_type'] || place['placeType'] && place['placeType']['name']
      @url = place['url']
      @woeid = place['woeid']
    end

    def ==(other)
      super || (other.class == self.class && other.id == @id)
    end

  end
end

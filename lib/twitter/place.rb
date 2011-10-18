require 'twitter/base'
require 'twitter/geo_factory'

module Twitter
  class Place < Twitter::Base
    attr_reader :bounding_box, :country_code, :parent_id, :place_type
    lazy_attr_reader :attributes, :country, :full_name, :id, :name, :url,
      :woeid

    def initialize(attributes={})
      attributes = attributes.dup
      @bounding_box = Twitter::GeoFactory.new(attributes['bounding_box']) unless attributes['bounding_box'].nil?
      @country_code = attributes['country_code'] || attributes['countryCode']
      @parent_id = attributes['parentid']
      @place_type = attributes['place_type'] || attributes['placeType'] && attributes['placeType']['name']
      super(attributes)
    end

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end

require 'twitter/base'
require 'twitter/geo_factory'

module Twitter
  class Place < Twitter::Base
    attr_reader :attributes, :country, :country_code, :full_name, :id, :name,
      :place_type, :url

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def bounding_box
      Twitter::GeoFactory.new(@bounding_box) if @bounding_box
    end
  end
end

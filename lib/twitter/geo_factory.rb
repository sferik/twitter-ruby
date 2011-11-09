require 'twitter/point'
require 'twitter/polygon'

module Twitter
  class GeoFactory

    # Instantiates a new geo object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a 'type' key.
    # @return [Twitter::Point, Twitter::Polygon]
    def self.new(geo={})
      type = geo.delete('type')
      if type
        Twitter.const_get(type.capitalize.to_sym).new(geo)
      else
        raise ArgumentError, "argument must have a 'type' key"
      end
    end

  end
end

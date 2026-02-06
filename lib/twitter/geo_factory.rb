require "twitter/factory"
require "twitter/geo/point"
require "twitter/geo/polygon"

module Twitter
  # Factory for creating geo objects based on type
  class GeoFactory < Twitter::Factory
    class << self
      # Constructs a new geo object
      #
      # @api public
      # @example
      #   Twitter::GeoFactory.new(type: "Point", coordinates: [1.0, 2.0])
      # @param attrs [Hash] The attributes hash with a :type key
      # @raise [IndexError] Error raised when argument is missing a :type key
      # @return [Twitter::Geo]
      def new(attrs = {})
        super(:type, Geo, attrs)
      end
    end
  end
end

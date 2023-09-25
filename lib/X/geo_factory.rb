require "X/factory"
require "X/geo/point"
require "X/geo/polygon"

module X
  class GeoFactory < X::Factory
    class << self
      # Construct a new geo object
      #
      # @param attrs [Hash]
      # @raise [IndexError] Error raised when supplied argument is missing a :type key.
      # @return [X::Geo]
      def new(attrs = {})
        super(:type, Geo, attrs)
      end
    end
  end
end

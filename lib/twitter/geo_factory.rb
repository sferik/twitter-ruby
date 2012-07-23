require 'twitter/factory'
require 'twitter/geo/point'
require 'twitter/geo/polygon'

module Twitter
  class GeoFactory < Twitter::Factory

    # Instantiates a new geo object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a :type key.
    # @return [Twitter::Geo]
    def self.fetch_or_new(attrs={})
      super(:type, Twitter::Geo, attrs)
    end

  end
end

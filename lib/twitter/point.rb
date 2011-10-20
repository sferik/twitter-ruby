require 'twitter/base'

module Twitter
  class Point < Twitter::Base
    lazy_attr_reader :coordinates

    # @param other [Twiter::Point]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.coordinates == self.coordinates)
    end

    # @return [Integer]
    def latitude
      coordinates[0]
    end
    alias :lat :latitude

    # @return [Integer]
    def longitude
      coordinates[1]
    end
    alias :long :longitude
    alias :lng :longitude

  end
end

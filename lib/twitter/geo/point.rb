require "twitter/geo"

module Twitter
  class Geo
    # Represents a geographic point with latitude and longitude
    class Point < Twitter::Geo
      # Returns the latitude of this point
      #
      # @api public
      # @example
      #   point.latitude
      # @return [Float]
      def latitude
        coordinates[0]
      end

      # @!method lat
      #   Returns the latitude of this point
      #   @api public
      #   @example
      #     point.lat
      #   @return [Float]
      alias_method :lat, :latitude

      # Returns the longitude of this point
      #
      # @api public
      # @example
      #   point.longitude
      # @return [Float]
      def longitude
        coordinates[1]
      end

      # @!method long
      #   Returns the longitude of this point
      #   @api public
      #   @example
      #     point.long
      #   @return [Float]
      alias_method :long, :longitude

      # @!method lng
      #   Returns the longitude of this point
      #   @api public
      #   @example
      #     point.lng
      #   @return [Float]
      alias_method :lng, :longitude
    end
  end
end

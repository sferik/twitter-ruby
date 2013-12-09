require 'twitter/geo'

module Twitter
  class Geo
    class Point < Twitter::Geo
      # @return [Integer]
      def latitude
        coordinates[0]
      end
      alias_method :lat, :latitude

      # @return [Integer]
      def longitude
        coordinates[1]
      end
      alias_method :long, :longitude
      alias_method :lng, :longitude
    end
  end
end

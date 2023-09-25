require "X/geo"

module X
  class Geo
    class Point < X::Geo
      # @return [Integer]
      def latitude
        coordinates[0]
      end
      alias lat latitude

      # @return [Integer]
      def longitude
        coordinates[1]
      end
      alias long longitude
      alias lng longitude
    end
  end
end

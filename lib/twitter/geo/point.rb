require 'twitter/geo'

module Twitter
  class Point < Twitter::Geo

    # @return [Integer]
    def latitude
      self.coordinates[0]
    end
    alias lat latitude

    # @return [Integer]
    def longitude
      self.coordinates[1]
    end
    alias long longitude
    alias lng longitude

  end
end

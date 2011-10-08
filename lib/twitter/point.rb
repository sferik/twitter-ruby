require 'twitter/base'

module Twitter
  class Point < Twitter::Base
    attr_reader :coordinates

    def latitude
      @coordinates[0]
    end
    alias :lat :latitude

    def longitude
      @coordinates[1]
    end
    alias :long :longitude
    alias :lng :longitude

  end
end

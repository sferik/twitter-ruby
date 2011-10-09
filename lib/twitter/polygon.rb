require 'twitter/base'

module Twitter
  class Polygon < Twitter::Base
    attr_reader :coordinates

    def ==(other)
      super || coordinates == other.coordinates
    end
  end
end

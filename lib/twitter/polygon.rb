require 'twitter/base'

module Twitter
  class Polygon < Twitter::Base
    attr_reader :coordinates

    # @param other [Twitter::Polygon]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.coordinates == self.coordinates)
    end

  end
end

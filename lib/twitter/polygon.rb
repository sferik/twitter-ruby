require 'twitter/base'

module Twitter
  class Polygon < Twitter::Base
    lazy_attr_reader :coordinates

    # @param other [Twiter::Polygon]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.coordinates == self.coordinates)
    end

  end
end

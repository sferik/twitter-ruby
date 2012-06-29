require 'twitter/base'

module Twitter
  class Geo < Twitter::Base
    attr_reader :coordinates
    alias coords coordinates

    # @param other [Twitter::Geo]
    # @return [Boolean]
    def ==(other)
      super || self.coordinates_equal(other) || self.attrs_equal(other)
    end

  protected

    # @param other [Twitter::Geo]
    # @return [Boolean]
    def coordinates_equal(other)
      self.class == other.class && !other.coordinates.nil? && self.coordinates == other.coordinates
    end

  end
end

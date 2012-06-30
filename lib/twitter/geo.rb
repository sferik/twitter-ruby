require 'twitter/base'

module Twitter
  class Geo < Twitter::Base
    attr_reader :coordinates
    alias coords coordinates

    # @param other [Twitter::Geo]
    # @return [Boolean]
    def ==(other)
      super || self.attr_equal(:coordinates, other) || self.attrs_equal(other)
    end

  end
end

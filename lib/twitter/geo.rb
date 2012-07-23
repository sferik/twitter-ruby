require 'twitter/base'

module Twitter
  class Geo < Twitter::Base
    attr_reader :coordinates
    alias coords coordinates

    # @param other [Twitter::Geo]
    # @return [Boolean]
    def ==(other)
      super || attr_equal(:coordinates, other) || attrs_equal(other)
    end

  end
end

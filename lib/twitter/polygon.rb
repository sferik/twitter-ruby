require 'twitter/base'

module Twitter
  class Polygon < Twitter::Base
    attr_reader :coordinates

    def ==(other)
      super || (other.class == self.class && other.instance_variable_get('@coordinates'.to_sym) == @coordinates)
    end

  end
end

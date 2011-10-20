require 'twitter/point'
require 'twitter/polygon'

module Twitter
  class GeoFactory

    def self.new(geo={})
      type = geo['type']
      if type
        Twitter.const_get(type.capitalize.to_sym).new(geo)
      else
        raise ArgumentError, "argument must have a type key"
      end
    end

  end
end

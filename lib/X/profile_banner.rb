require "memoizable"
require "X/base"

module X
  class ProfileBanner < X::Base
    include Memoizable

    # Returns an array of photo sizes
    #
    # @return [Array<X::Size>]
    def sizes
      @attrs.fetch(:sizes, []).each_with_object({}) do |(key, value), object|
        object[key] = Size.new(value)
      end
    end
    memoize :sizes
  end
end

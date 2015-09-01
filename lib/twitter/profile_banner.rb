require 'memoizable'
require 'twitter/base'

module Twitter
  class ProfileBanner < Twitter::Base
    include Memoizable

    # Returns an array of photo sizes
    #
    # @return [Array<Twitter::Size>]
    def sizes
      @attrs.fetch(:sizes, []).inject({}) do |object, (key, value)|
        object[key] = Size.new(value)
        object
      end
    end
    memoize :sizes
  end
end

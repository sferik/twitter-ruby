require "memoizable"
require "twitter/base"

module Twitter
  # Represents a user's profile banner
  class ProfileBanner < Twitter::Base
    include Memoizable

    # Returns a hash of banner sizes
    #
    # @api public
    # @example
    #   profile_banner.sizes
    # @return [Hash{Symbol => Twitter::Size}]
    def sizes
      result = {} #: Hash[Symbol, Size]
      @attrs.fetch(:sizes, []).each_with_object(result) do |(key, value), object|
        object[key] = Size.new(value)
      end
    end
    memoize :sizes
  end
end

require 'twitter/base'

module Twitter
  class ProfileBanner < Twitter::Base

    # Returns an array of photo sizes
    #
    # @return [Array<Twitter::Size>]
    def sizes
      memoize(:sizes) do
        Array(@attrs[:sizes]).each_with_object({}) do |(key, value), object|
          object[key] = Twitter::Size.new(value)
        end
      end
    end

  end
end

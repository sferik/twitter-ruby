require 'twitter/base'

module Twitter
  class ProfileBanner < Twitter::Base

    # Returns an array of photo sizes
    #
    # @return [Array<Twitter::Size>]
    def sizes
      memoize(:sizes) do
        Array(@attrs[:sizes]).inject({}) do |object, (key, value)|
          object[key] = Twitter::Size.new(value)
          object
        end
      end
    end

  end
end

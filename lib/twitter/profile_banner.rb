require 'twitter/base'

module Twitter
  class ProfileBanner < Twitter::Base

    # Returns an array of photo sizes
    #
    # @return [Array<Twitter::Size>]
    def sizes
      @sizes ||= Array(@attrs[:sizes]).inject({}) do |object, (key, value)|
        object[key] = Twitter::Size.fetch_or_new(value)
        object
      end
    end

  end
end

require 'twitter/base'

module Twitter
  class ProfileBanner < Twitter::Base

    # Returns an array of photo sizes
    #
    # @return [Array<Twitter::Size>]
    def sizes
      @sizes ||= Array(@attrs[:sizes]).each_with_object({}) do |(key, value), object|
        object[key] = Twitter::Size.fetch_or_new(value)
      end
    end

  end
end

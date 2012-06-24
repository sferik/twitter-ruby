require 'twitter/base'

module Twitter
  class RateLimitStatus < Twitter::Base
    attr_reader :hourly_limit, :remaining_hits, :reset_time_in_seconds

    # Time when the authenticating user's rate limit will be reset
    #
    # @return [Time]
    def reset_time
      @reset_time ||= Time.parse(@attrs[:reset_time]) unless @attrs[:reset_time].nil?
    end

  end
end

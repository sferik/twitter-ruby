require 'twitter/base'

module Twitter
  class RateLimitStatus < Twitter::Base
    lazy_attr_reader :hourly_limit, :remaining_hits, :reset_time_in_seconds

    def reset_time
      @reset_time ||= Time.parse(@attrs['reset_time']) unless @attrs['reset_time'].nil?
    end

  end
end

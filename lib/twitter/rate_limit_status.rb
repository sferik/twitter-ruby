require 'twitter/base'

module Twitter
  class RateLimitStatus < Twitter::Base
    attr_reader :hourly_limit, :remaining_hits, :reset_time_in_seconds

    # Time when the rate limit resets
    #
    # @return [Time]
    def reset_time
      @reset_time = Time.parse(@reset_time) unless @reset_time.nil? || @reset_time.is_a?(Time)
    end
  end
end

require 'twitter/base'

module Twitter
  class RateLimitStatus < Twitter::Base
    attr_reader :hourly_limit, :remaining_hits, :reset_time, :reset_time_in_seconds

    def initialize(rate_limit_status={})
      @reset_time = Time.parse(rate_limit_status.delete('reset_time')) unless rate_limit_status['reset_time'].nil?
      super(rate_limit_status)
    end

  end
end

require 'twitter/base'

module Twitter
  class RateLimitStatus < Twitter::Base
    attr_reader :reset_time
    lazy_attr_reader :hourly_limit, :remaining_hits, :reset_time_in_seconds

    def initialize(attributes={})
      attributes = attributes.dup
      @reset_time = Time.parse(attributes['reset_time']) unless attributes['reset_time'].nil?
      super(attributes)
    end

  end
end

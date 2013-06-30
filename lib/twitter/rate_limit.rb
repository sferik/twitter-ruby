module Twitter
  class RateLimit < Twitter::Base

    # @return [Integer]
    def limit
      limit = @attrs['x-rate-limit-limit']
      limit.to_i if limit
    end

    # @return [Integer]
    def remaining
      remaining = @attrs['x-rate-limit-remaining']
      remaining.to_i if remaining
    end

    # @return [Time]
    def reset_at
      reset = @attrs['x-rate-limit-reset']
      Time.at(reset.to_i) if reset
    end

    # @return [Integer]
    def reset_in
      [(reset_at - Time.now).ceil, 0].max if reset_at
    end
    alias retry_after reset_in

  end
end

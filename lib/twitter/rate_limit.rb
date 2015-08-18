module Twitter
  class RateLimit < Twitter::Base
    # @return [Integer]
    def limit
      limit = @attrs['x-rate-limit-limit']
      limit.to_i if limit
    end
    memoize :limit

    # @return [Integer]
    def remaining
      remaining = @attrs['x-rate-limit-remaining']
      remaining.to_i if remaining
    end
    memoize :remaining

    # @return [Time]
    def reset_at
      reset = @attrs['x-rate-limit-reset']
      Time.at(reset.to_i).utc if reset
    end
    memoize :reset_at

    # @return [Integer]
    def reset_in
      [(reset_at - Time.now).ceil, 0].max if reset_at
    end
    alias_method :retry_after, :reset_in

    # @return [Integer]
    def cost
      cost = @attrs['x-request-cost']
      cost.to_i if cost
    end
    memoize :cost
  end
end

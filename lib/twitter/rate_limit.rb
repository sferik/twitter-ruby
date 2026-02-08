require "memoizable"

module Twitter
  # Represents rate limit information from Twitter API responses
  class RateLimit < Base
    include Memoizable

    # Returns the rate limit ceiling for this request
    #
    # @api public
    # @example
    #   rate_limit.limit
    # @return [Integer]
    def limit
      limit = @attrs["x-rate-limit-limit"]
      limit&.to_i
    end
    memoize :limit

    # Returns the number of requests remaining
    #
    # @api public
    # @example
    #   rate_limit.remaining
    # @return [Integer]
    def remaining
      remaining = @attrs["x-rate-limit-remaining"]
      remaining&.to_i
    end
    memoize :remaining

    # Returns the time when the rate limit resets
    #
    # @api public
    # @example
    #   rate_limit.reset_at
    # @return [Time]
    def reset_at
      reset = @attrs["x-rate-limit-reset"]
      Time.at(reset.to_i).utc if reset
    end
    memoize :reset_at

    # Returns the number of seconds until the rate limit resets
    #
    # @api public
    # @example
    #   rate_limit.reset_in
    # @return [Integer]
    def reset_in
      time = reset_at
      [(time - Time.now).ceil, 0].max if time
    end

    # @!method retry_after
    #   Returns the number of seconds until the rate limit resets
    #   @api public
    #   @example
    #     rate_limit.retry_after
    #   @return [Integer]
    alias_method :retry_after, :reset_in
  end
end

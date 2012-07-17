module Twitter
  class RateLimit
    attr_reader :attrs
    alias to_hash attrs

    # @deprecated This method exists to provide backwards compatibility to when
    #   Twitter::RateLimit was a singleton. Safe to remove in version 4.
    def self.instance
      Twitter.rate_limit
    end

    # @return [Twitter::RateLimit]
    def initialize(attrs={})
      @attrs = attrs
    end

    # @return [String]
    def class
      @attrs.values_at('x-ratelimit-class', 'X-RateLimit-Class').compact.first
    end

    # @return [Integer]
    def limit
      limit = @attrs.values_at('x-ratelimit-limit', 'X-RateLimit-Limit').compact.first
      limit.to_i if limit
    end

    # @return [Integer]
    def remaining
      remaining = @attrs.values_at('x-ratelimit-remaining', 'X-RateLimit-Remaining').compact.first
      remaining.to_i if remaining
    end

    # @return [Time]
    def reset_at
      reset = @attrs.values_at('x-ratelimit-reset', 'X-RateLimit-Reset').compact.first
      Time.at(reset.to_i) if reset
    end

    # @return [Integer]
    def reset_in
      if retry_after = @attrs.values_at('retry-after', 'Retry-After').compact.first
        retry_after.to_i
      elsif reset_at
        [(reset_at - Time.now).ceil, 0].max
      end
    end
    alias retry_after reset_in

    # Update the attributes of a Relationship
    #
    # @param attrs [Hash]
    # @return [Twitter::RateLimit]
    def update(attrs)
      @attrs.update(attrs)
      self
    end

  end
end

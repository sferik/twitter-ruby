module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError
    attr_reader :http_headers

    # Initializes a new Error object
    #
    # @param message [String]
    # @param http_headers [Hash]
    # @return [Twitter::Error]
    def initialize(message, http_headers)
      @http_headers = Hash[http_headers]
      super(message)
    end

    # @return [Time]
    def ratelimit_reset
      reset = @http_headers.values_at('x-ratelimit-reset', 'X-RateLimit-Reset').compact.first
      Time.at(reset.to_i) if reset
    end

    # @return [String]
    def ratelimit_class
      @http_headers.values_at('x-ratelimit-class', 'X-RateLimit-Class').compact.first
    end

    # @return [Integer]
    def ratelimit_limit
      limit = @http_headers.values_at('x-ratelimit-limit', 'X-RateLimit-Limit').compact.first
      limit.to_i if limit
    end

    # @return [Integer]
    def ratelimit_remaining
      remaining = @http_headers.values_at('x-ratelimit-remaining', 'X-RateLimit-Remaining').compact.first
      remaining.to_i if remaining
    end

    # @return [Integer]
    def retry_after
      reset = ratelimit_reset
      [(ratelimit_reset - Time.now).ceil, 0].max if reset
    end

  end
end

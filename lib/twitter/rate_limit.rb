require 'singleton'

module Twitter
  class RateLimit
    include Singleton
    attr_accessor :response_headers
    alias headers response_headers

    def initialize
      self.reset!
    end

    # @return [String]
    def class
      @response_headers.values_at('x-ratelimit-class', 'X-RateLimit-Class').compact.first
    end

    # @return [Integer]
    def limit
      limit = @response_headers.values_at('x-ratelimit-limit', 'X-RateLimit-Limit').compact.first
      limit.to_i if limit
    end

    # @return [Integer]
    def remaining
      remaining = @response_headers.values_at('x-ratelimit-remaining', 'X-RateLimit-Remaining').compact.first
      remaining.to_i if remaining
    end

    def reset!
      @response_headers = {}
      self
    end

    # @return [Time]
    def reset_at
      reset = @response_headers.values_at('x-ratelimit-reset', 'X-RateLimit-Reset').compact.first
      Time.at(reset.to_i) if reset
    end

    # @return [Integer]
    def reset_in
      [(reset_at - Time.now).ceil, 0].max if reset_at
    end

    # Update the attributes of a Relationship
    #
    # @param response_headers [Hash]
    # @return [Twitter::RateLimit]
    def update(response_headers)
      @response_headers.update(response_headers)
      self
    end

  end
end

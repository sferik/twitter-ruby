module Twitter
  module Error
    attr_reader :http_headers

    module ClassMethods

      def errors
        return @errors if defined? @errors
        array = descendants.map do |klass|
          [klass.const_get(:HTTP_STATUS_CODE), klass]
        end.flatten
        @errors = Hash[*array]
      end

    private

      def descendants
        ObjectSpace.each_object(::Class).select{|klass| klass < self}
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    # Initializes a new Error object
    #
    # @param message [String]
    # @param http_headers [Hash]
    # @return [Twitter::Error]
    def initialize(message=nil, http_headers={})
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

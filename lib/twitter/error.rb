module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError
    attr_reader :rate_limit, :wrapped_exception

    def self.errors
      @errors ||= Hash[descendants.map{|klass| [klass.const_get(:HTTP_STATUS_CODE), klass]}]
    end

    def self.descendants
      ObjectSpace.each_object(::Class).select{|klass| klass < self}
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @return [Twitter::Error]
    def initialize(exception=$!, response_headers={})
      @rate_limit = Twitter::RateLimit.new(response_headers)
      if exception.respond_to?(:backtrace)
        super(exception.message)
        @wrapped_exception = exception
      else
        super(exception.to_s)
      end
    end

    def backtrace
      @wrapped_exception ? @wrapped_exception.backtrace : super
    end

  end
end

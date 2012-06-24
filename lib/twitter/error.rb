require 'twitter/rate_limit'

module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError
    attr_reader :wrapped_exception

    def self.errors
      return @errors if defined? @errors
      array = descendants.map do |klass|
        [klass.const_get(:HTTP_STATUS_CODE), klass]
      end.flatten
      @errors = Hash[*array]
    end

    def self.descendants
      ObjectSpace.each_object(::Class).select{|klass| klass < self}
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @param response_headers [Hash]
    # @return [Twitter::Error]
    def initialize(exception=$!, response_headers={})
      self.update_rate_limit(response_headers) unless response_headers.empty?
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

  protected

    # Update the RateLimit object
    #
    # @param response_headers [Hash]
    # @return [Twitter::RateLimit]
    def update_rate_limit(response_headers)
      Twitter::RateLimit.instance.update(response_headers)
    end

  end
end

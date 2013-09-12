require 'twitter/rate_limit'

module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError
    attr_reader :rate_limit, :wrapped_exception, :code

    # If error code is missing see https://dev.twitter.com/docs/error-codes-responses
    module Codes
      AUTHENTICATION_PROBLEM       = 32
      RESOURCE_NOT_FOUND           = 34
      SUSPENDED_ACCOUNT            = 64
      DEPRECATED_CALL              = 68
      RATE_LIMIT_EXCEEDED          = 88
      INVALID_OR_EXPIRED_TOKEN     = 89
      OVER_CAPACITY                = 130
      INTERNAL_ERROR               = 131
      OAUTH_TIMESTAMP_OUT_OF_RANGE = 135
      DUPLICATE_STATUS             = 187
      BAD_AUTHENTICATION_DATA      = 215
      LOGIN_VERIFICATION_NEEDED    = 231
    end

    # Create a new error from an HTTP response
    #
    # @param response [Hash]
    # @return [Twitter::Error]
    def self.from_response(response={})
      error, code = parse_error(response[:body])
      new(error, response[:response_headers], code)
    end

    # @return [Hash]
    def self.errors
      @errors ||= descendants.inject({}) do |hash, klass|
        hash[klass::HTTP_STATUS_CODE] = klass
        hash
      end
    end

    # @return [Array]
    def self.descendants
      @descendants ||= []
    end

    # @return [Array]
    def self.inherited(descendant)
      descendants << descendant
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @param response_headers [Hash]
    # @param code [Integer]
    # @return [Twitter::Error]
    def initialize(exception=$!, response_headers={}, code=nil)
      @rate_limit = Twitter::RateLimit.new(response_headers)
      @wrapped_exception = exception
      @code = code
      exception.respond_to?(:message) ? super(exception.message) : super(exception.to_s)
    end

  private

    def self.parse_error(body)
      if body.nil?
        ['', nil]
      elsif body[:error]
        [body[:error], nil]
      elsif body[:errors]
        first = Array(body[:errors]).first
        if first.is_a?(Hash)
          [first[:message].chomp, first[:code]]
        else
          [first.chomp, nil]
        end
      end
    end

  end
end

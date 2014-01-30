require 'twitter/rate_limit'

module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError
    attr_reader :cause, :code, :rate_limit
    alias_method :wrapped_exception, :cause

    # If error code is missing see https://dev.twitter.com/docs/error-codes-responses
    module Code
      AUTHENTICATION_PROBLEM       = 32
      RESOURCE_NOT_FOUND           = 34
      SUSPENDED_ACCOUNT            = 64
      DEPRECATED_CALL              = 68
      RATE_LIMIT_EXCEEDED          = 88
      INVALID_OR_EXPIRED_TOKEN     = 89
      UNABLE_TO_VERIFY_CREDENTIALS = 99
      OVER_CAPACITY                = 130
      INTERNAL_ERROR               = 131
      OAUTH_TIMESTAMP_OUT_OF_RANGE = 135
      ALREADY_FAVORITED            = 139
      FOLLOW_ALREADY_REQUESTED     = 160
      FOLLOW_LIMIT_EXCEEDED        = 161
      PROTECTED_STATUS             = 179
      OVER_UPDATE_LIMIT            = 185
      DUPLICATE_STATUS             = 187
      BAD_AUTHENTICATION_DATA      = 215
      LOGIN_VERIFICATION_NEEDED    = 231
      ENDPOINT_RETIRED             = 251
    end
    Codes = Code # rubocop:disable ConstantName

    class << self
      # Create a new error from an HTTP response
      #
      # @param response [Hash]
      # @return [Twitter::Error]
      def from_response(response = {})
        error, code = parse_error(response.body)
        new(error, response.response_headers, code)
      end

      # @return [Hash]
      def errors
        @errors ||= {
          400 => Twitter::Error::BadRequest,
          401 => Twitter::Error::Unauthorized,
          403 => Twitter::Error::Forbidden,
          404 => Twitter::Error::NotFound,
          406 => Twitter::Error::NotAcceptable,
          408 => Twitter::Error::RequestTimeout,
          422 => Twitter::Error::UnprocessableEntity,
          429 => Twitter::Error::TooManyRequests,
          500 => Twitter::Error::InternalServerError,
          502 => Twitter::Error::BadGateway,
          503 => Twitter::Error::ServiceUnavailable,
          504 => Twitter::Error::GatewayTimeout,
        }
      end

    private

      def parse_error(body)
        if body.nil?
          ['', nil]
        elsif body[:error]
          [body[:error], nil]
        elsif body[:errors]
          extract_message_from_errors(body)
        end
      end

      def extract_message_from_errors(body)
        first = Array(body[:errors]).first
        if first.is_a?(Hash)
          [first[:message].chomp, first[:code]]
        else
          [first.chomp, nil]
        end
      end
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @param response_headers [Hash]
    # @param code [Integer]
    # @return [Twitter::Error]
    def initialize(exception = $ERROR_INFO, response_headers = {}, code = nil)
      @rate_limit = RateLimit.new(response_headers)
      @cause = exception
      @code = code
      exception.respond_to?(:message) ? super(exception.message) : super(exception.to_s)
    end

    class ConfigurationError < ::ArgumentError; end

    # Raised when Twitter returns a 4xx HTTP status code
    class ClientError < self; end

    # Raised when Twitter returns the HTTP status code 400
    class BadRequest < ClientError; end

    # Raised when Twitter returns the HTTP status code 401
    class Unauthorized < ClientError; end

    # Raised when Twitter returns the HTTP status code 403
    class Forbidden < ClientError; end

    # Raised when a Tweet has already been favorited
    class AlreadyFavorited < Forbidden
      MESSAGE = 'You have already favorited this status.'
    end

    # Raised when a Tweet has already been posted
    class AlreadyPosted < Forbidden
      MESSAGE = 'Status is a duplicate.'
    end

    # Raised when a Tweet has already been retweeted
    class AlreadyRetweeted < Forbidden
      MESSAGE = 'sharing is not permissible for this status (Share validations failed)'
    end

    # Raised when Twitter returns the HTTP status code 404
    class NotFound < ClientError; end

    # Raised when Twitter returns the HTTP status code 406
    class NotAcceptable < ClientError; end

    # Raised when Twitter returns the HTTP status code 408
    class RequestTimeout < ClientError; end

    # Raised when Twitter returns the HTTP status code 422
    class UnprocessableEntity < ClientError; end

    # Raised when Twitter returns the HTTP status code 429
    class TooManyRequests < ClientError; end
    EnhanceYourCalm = TooManyRequests # rubocop:disable ConstantName
    RateLimited = TooManyRequests # rubocop:disable ConstantName

    # Raised when Twitter returns a 5xx HTTP status code
    class ServerError < self; end

    # Raised when Twitter returns the HTTP status code 500
    class InternalServerError < ServerError; end

    # Raised when Twitter returns the HTTP status code 502
    class BadGateway < ServerError; end

    # Raised when Twitter returns the HTTP status code 503
    class ServiceUnavailable < ServerError; end

    # Raised when Twitter returns the HTTP status code 504
    class GatewayTimeout < ServerError; end
  end
end

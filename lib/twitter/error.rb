require "twitter/rate_limit"

module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError
    # The error code from Twitter
    #
    # @api public
    # @example
    #   error.code
    # @return [Integer]
    attr_reader :code

    # The rate limit information from the response
    #
    # @api public
    # @example
    #   error.rate_limit
    # @return [Twitter::RateLimit]
    attr_reader :rate_limit

    # Raised when Twitter returns a 4xx HTTP status code
    ClientError = Class.new(self) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 400
    BadRequest = Class.new(ClientError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 401
    Unauthorized = Class.new(ClientError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 403
    Forbidden = Class.new(ClientError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 413
    RequestEntityTooLarge = Class.new(ClientError) # steep:ignore IncompatibleAssignment

    # Raised when a Tweet has already been favorited
    AlreadyFavorited = Class.new(Forbidden) # steep:ignore IncompatibleAssignment

    # Raised when a Tweet has already been retweeted
    AlreadyRetweeted = Class.new(Forbidden) # steep:ignore IncompatibleAssignment

    # Raised when a Tweet has already been posted
    DuplicateStatus = Class.new(Forbidden) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 404
    NotFound = Class.new(ClientError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 406
    NotAcceptable = Class.new(ClientError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 422
    UnprocessableEntity = Class.new(ClientError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 429
    TooManyRequests = Class.new(ClientError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns a 5xx HTTP status code
    ServerError = Class.new(self) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 500
    InternalServerError = Class.new(ServerError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 502
    BadGateway = Class.new(ServerError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 503
    ServiceUnavailable = Class.new(ServerError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns the HTTP status code 504
    GatewayTimeout = Class.new(ServerError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns a media related error
    MediaError = Class.new(self) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns an InvalidMedia error
    InvalidMedia = Class.new(MediaError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns a media InternalError error
    MediaInternalError = Class.new(MediaError) # steep:ignore IncompatibleAssignment

    # Raised when Twitter returns an UnsupportedMedia error
    UnsupportedMedia = Class.new(MediaError) # steep:ignore IncompatibleAssignment

    # Raised when an operation subject to timeout takes too long
    TimeoutError = Class.new(self) # steep:ignore IncompatibleAssignment

    # Maps HTTP status codes to error classes
    ERRORS = {
      400 => Twitter::Error::BadRequest,
      401 => Twitter::Error::Unauthorized,
      403 => Twitter::Error::Forbidden,
      404 => Twitter::Error::NotFound,
      406 => Twitter::Error::NotAcceptable,
      413 => Twitter::Error::RequestEntityTooLarge,
      420 => Twitter::Error::TooManyRequests,
      422 => Twitter::Error::UnprocessableEntity,
      429 => Twitter::Error::TooManyRequests,
      500 => Twitter::Error::InternalServerError,
      502 => Twitter::Error::BadGateway,
      503 => Twitter::Error::ServiceUnavailable,
      504 => Twitter::Error::GatewayTimeout,
    }.freeze

    # Maps forbidden message patterns to error classes
    FORBIDDEN_MESSAGES = proc do |message|
      case message
      when /(?=.*status).*duplicate/i
        # - "Status is a duplicate."
        Twitter::Error::DuplicateStatus
      when /already favorited/i
        # - "You have already favorited this status."
        Twitter::Error::AlreadyFavorited
      when /already retweeted|Share validations failed/i
        # - "You have already retweeted this Tweet." (Nov 2017-)
        # - "You have already retweeted this tweet." (?-Nov 2017)
        # - "sharing is not permissible for this status (Share validations failed)" (-? 2017)
        Twitter::Error::AlreadyRetweeted
      end
    end

    # Maps media error names to error classes
    MEDIA_ERRORS = {
      "InternalError" => Twitter::Error::MediaInternalError,
      "InvalidMedia" => Twitter::Error::InvalidMedia,
      "UnsupportedMedia" => Twitter::Error::UnsupportedMedia,
    }.freeze

    # Twitter API error codes
    # @see https://developer.twitter.com/en/docs/basics/response-codes
    module Code
      # Authentication problem error code
      AUTHENTICATION_PROBLEM       =  32
      # Resource not found error code
      RESOURCE_NOT_FOUND           =  34
      # Suspended account error code
      SUSPENDED_ACCOUNT            =  64
      # Deprecated call error code
      DEPRECATED_CALL              =  68
      # Rate limit exceeded error code
      RATE_LIMIT_EXCEEDED          =  88
      # Invalid or expired token error code
      INVALID_OR_EXPIRED_TOKEN     =  89
      # SSL required error code
      SSL_REQUIRED                 =  92
      # Unable to verify credentials error code
      UNABLE_TO_VERIFY_CREDENTIALS =  99
      # Over capacity error code
      OVER_CAPACITY                = 130
      # Internal error code
      INTERNAL_ERROR               = 131
      # OAuth timestamp out of range error code
      OAUTH_TIMESTAMP_OUT_OF_RANGE = 135
      # Already favorited error code
      ALREADY_FAVORITED            = 139
      # Follow already requested error code
      FOLLOW_ALREADY_REQUESTED     = 160
      # Follow limit exceeded error code
      FOLLOW_LIMIT_EXCEEDED        = 161
      # Protected status error code
      PROTECTED_STATUS             = 179
      # Over update limit error code
      OVER_UPDATE_LIMIT            = 185
      # Duplicate status error code
      DUPLICATE_STATUS             = 187
      # Bad authentication data error code
      BAD_AUTHENTICATION_DATA      = 215
      # Spam error code
      SPAM                         = 226
      # Login verification needed error code
      LOGIN_VERIFICATION_NEEDED    = 231
      # Endpoint retired error code
      ENDPOINT_RETIRED             = 251
      # Cannot write error code
      CANNOT_WRITE                 = 261
      # Cannot mute error code
      CANNOT_MUTE                  = 271
      # Cannot unmute error code
      CANNOT_UNMUTE                = 272
    end

    class << self
      include Twitter::Utils

      # Creates a new error from an HTTP response
      #
      # @api public
      # @example
      #   Twitter::Error.from_response(body, headers)
      # @param body [String] The response body
      # @param headers [Hash] The response headers
      # @return [Twitter::Error]
      def from_response(body, headers)
        message, code = parse_error(body)
        new(message, headers, code)
      end

      # Creates a new error from a media error hash
      #
      # @api public
      # @example
      #   Twitter::Error.from_processing_response(error, headers)
      # @param error [Hash] The error hash from the response
      # @param headers [Hash] The response headers
      # @return [Twitter::MediaError]
      def from_processing_response(error, headers)
        klass = MEDIA_ERRORS[error[:name]] || self
        message = error[:message]
        code = error[:code]
        klass.new(message, headers, code)
      end

    private

      # Parses an error from the response body
      #
      # @api private
      # @param body [Hash, nil] The response body
      # @return [Array]
      def parse_error(body)
        if body.nil? || body.empty?
          ["", nil]
        elsif body[:error]
          [body.fetch(:error), nil]
        elsif body[:errors]
          extract_message_from_errors(body)
        end
      end

      # Extracts error message from errors array
      #
      # @api private
      # @param body [Hash] The response body with errors
      # @return [Array]
      def extract_message_from_errors(body)
        first = Array(body[:errors]).first
        if first.is_a?(Hash)
          [first[:message].chomp, first[:code]]
        else
          [first.chomp, nil] # steep:ignore NoMethod
        end
      end
    end

    # Initializes a new Error object
    #
    # @api public
    # @example
    #   Twitter::Error.new("Something went wrong", {}, 123)
    # @param message [Exception, String] The error message
    # @param rate_limit [Hash] The rate limit headers
    # @param code [Integer] The error code
    # @return [Twitter::Error]
    def initialize(message = "", rate_limit = {}, code = nil)
      super(message)
      @rate_limit = RateLimit.new(rate_limit)
      @code = code
    end
  end
end

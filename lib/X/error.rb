require "X/rate_limit"

module X
  # Custom error class for rescuing from all X errors
  class Error < StandardError
    # @return [Integer]
    attr_reader :code
    # @return [X::RateLimit]
    attr_reader :rate_limit

    # Raised when X returns a 4xx HTTP status code
    ClientError = Class.new(self)

    # Raised when X returns the HTTP status code 400
    BadRequest = Class.new(ClientError)

    # Raised when X returns the HTTP status code 401
    Unauthorized = Class.new(ClientError)

    # Raised when X returns the HTTP status code 403
    Forbidden = Class.new(ClientError)

    # Raised when X returns the HTTP status code 413
    RequestEntityTooLarge = Class.new(ClientError)

    # Raised when a Tweet has already been favorited
    AlreadyFavorited = Class.new(Forbidden)

    # Raised when a Tweet has already been retweeted
    AlreadyRetweeted = Class.new(Forbidden)

    # Raised when a Tweet has already been posted
    DuplicateStatus = Class.new(Forbidden)

    # Raised when X returns the HTTP status code 404
    NotFound = Class.new(ClientError)

    # Raised when X returns the HTTP status code 406
    NotAcceptable = Class.new(ClientError)

    # Raised when X returns the HTTP status code 422
    UnprocessableEntity = Class.new(ClientError)

    # Raised when X returns the HTTP status code 429
    TooManyRequests = Class.new(ClientError)

    # Raised when X returns a 5xx HTTP status code
    ServerError = Class.new(self)

    # Raised when X returns the HTTP status code 500
    InternalServerError = Class.new(ServerError)

    # Raised when X returns the HTTP status code 502
    BadGateway = Class.new(ServerError)

    # Raised when X returns the HTTP status code 503
    ServiceUnavailable = Class.new(ServerError)

    # Raised when X returns the HTTP status code 504
    GatewayTimeout = Class.new(ServerError)

    # Raised when X returns a media related error
    MediaError = Class.new(self)

    # Raised when X returns an InvalidMedia error
    InvalidMedia = Class.new(MediaError)

    # Raised when X returns a media InternalError error
    MediaInternalError = Class.new(MediaError)

    # Raised when X returns an UnsupportedMedia error
    UnsupportedMedia = Class.new(MediaError)

    # Raised when an operation subject to timeout takes too long
    TimeoutError = Class.new(self)

    ERRORS = {
      400 => X::Error::BadRequest,
      401 => X::Error::Unauthorized,
      403 => X::Error::Forbidden,
      404 => X::Error::NotFound,
      406 => X::Error::NotAcceptable,
      413 => X::Error::RequestEntityTooLarge,
      420 => X::Error::TooManyRequests,
      422 => X::Error::UnprocessableEntity,
      429 => X::Error::TooManyRequests,
      500 => X::Error::InternalServerError,
      502 => X::Error::BadGateway,
      503 => X::Error::ServiceUnavailable,
      504 => X::Error::GatewayTimeout,
    }.freeze

    FORBIDDEN_MESSAGES = proc do |message|
      case message
      when /(?=.*status).*duplicate/i
        # - "Status is a duplicate."
        X::Error::DuplicateStatus
      when /already favorited/i
        # - "You have already favorited this status."
        X::Error::AlreadyFavorited
      when /already retweeted|Share validations failed/i
        # - "You have already retweeted this Tweet." (Nov 2017-)
        # - "You have already retweeted this tweet." (?-Nov 2017)
        # - "sharing is not permissible for this status (Share validations failed)" (-? 2017)
        X::Error::AlreadyRetweeted
      end
    end

    MEDIA_ERRORS = {
      "InternalError" => X::Error::MediaInternalError,
      "InvalidMedia" => X::Error::InvalidMedia,
      "UnsupportedMedia" => X::Error::UnsupportedMedia,
    }.freeze

    # If error code is missing see https://developer.X.com/en/docs/basics/response-codes
    module Code
      AUTHENTICATION_PROBLEM       =  32
      RESOURCE_NOT_FOUND           =  34
      SUSPENDED_ACCOUNT            =  64
      DEPRECATED_CALL              =  68
      RATE_LIMIT_EXCEEDED          =  88
      INVALID_OR_EXPIRED_TOKEN     =  89
      SSL_REQUIRED                 =  92
      UNABLE_TO_VERIFY_CREDENTIALS =  99
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
      SPAM                         = 226
      LOGIN_VERIFICATION_NEEDED    = 231
      ENDPOINT_RETIRED             = 251
      CANNOT_WRITE                 = 261
      CANNOT_MUTE                  = 271
      CANNOT_UNMUTE                = 272
    end

    class << self
      include X::Utils

      # Create a new error from an HTTP response
      #
      # @param body [String]
      # @param headers [Hash]
      # @return [X::Error]
      def from_response(body, headers)
        message, code = parse_error(body)
        new(message, headers, code)
      end

      # Create a new error from a media error hash
      #
      # @param error [Hash]
      # @param headers [Hash]
      # @return [X::MediaError]
      def from_processing_response(error, headers)
        klass = MEDIA_ERRORS[error[:name]] || self
        message = error[:message]
        code = error[:code]
        klass.new(message, headers, code)
      end

    private

      def parse_error(body)
        if body.nil? || body.empty?
          ["", nil]
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
    # @param message [Exception, String]
    # @param rate_limit [Hash]
    # @param code [Integer]
    # @return [X::Error]
    def initialize(message = "", rate_limit = {}, code = nil)
      super(message)
      @rate_limit = X::RateLimit.new(rate_limit)
      @code = code
    end
  end
end

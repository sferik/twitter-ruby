module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError; end

  # Raised when Twitter returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Twitter returns the HTTP status code 401
  class Unauthorized < Error; end

  # Raised when Twitter returns the HTTP status code 403
  class Forbidden < Error; end

  # Raised when Twitter returns the HTTP status code 404
  class NotFound < Error; end

  # Raised when Twitter returns the HTTP status code 406
  class NotAcceptable < Error; end

  # Raised when Twitter returns the HTTP status code 420
  class EnhanceYourCalm < Error
    # Creates a new EnhanceYourCalm error
    def initialize(message, http_headers)
      @http_headers = Hash[http_headers]
      super message
    end

    # The number of seconds your application should wait before requesting date from the Search API again
    #
    # @see http://dev.twitter.com/pages/rate-limiting
    def retry_after
      @http_headers.values_at('retry-after', 'Retry-After').first.to_i
    end
  end

  # Raised when Twitter returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Twitter returns the HTTP status code 502
  class BadGateway < Error; end

  # Raised when Twitter returns the HTTP status code 503
  class ServiceUnavailable < Error; end
end

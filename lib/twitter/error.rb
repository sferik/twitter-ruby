module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError; end

  # Raised when Twitter returns a 400 HTTP status code
  class BadRequest < Error; end

  # Raised when Twitter returns a 401 HTTP status code
  class Unauthorized < Error; end

  # Raised when Twitter returns a 403 HTTP status code
  class Forbidden < Error; end

  # Raised when Twitter returns a 404 HTTP status code
  class NotFound < Error; end

  # Raised when Twitter returns a 406 HTTP status code
  class NotAcceptable < Error; end

  # Raised when Twitter returns a 420 HTTP status code
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

  # Raised when Twitter returns a 500 HTTP status code
  class InternalServerError < Error; end

  # Raised when Twitter returns a 502 HTTP status code
  class BadGateway < Error; end

  # Raised when Twitter returns a 503 HTTP status code
  class ServiceUnavailable < Error; end
end

module Twitter
  class Error < StandardError; end

  class BadGateway < Error; end
  class BadRequest < Error; end
  class Forbidden < Error; end
  class InternalServerError < Error; end
  class NotAcceptable < Error; end
  class NotFound < Error; end
  class ServiceUnavailable < Error; end
  class Unauthorized < Error; end

  class EnhanceYourCalm < Error
    def initialize(message, http_headers)
      @http_headers = Hash[http_headers]
      super message
    end

    def retry_after
      @http_headers.values_at('retry-after', 'Retry-After').first.to_i
    end
  end
end

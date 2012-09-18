require 'twitter/error/client_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 429
    class RateLimited < Twitter::Error::ClientError
      HTTP_STATUS_CODE = 429
    end
    EnhanceYourCalm = RateLimited
  end
end

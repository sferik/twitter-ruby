require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 429
    class TooManyRequests < Twitter::Error
      HTTP_STATUS_CODE = 429
    end
    EnhanceYourCalm = TooManyRequests
    RateLimited = TooManyRequests
  end
end

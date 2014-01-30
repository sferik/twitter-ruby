require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 429
    class TooManyRequests < Twitter::Error; end
    EnhanceYourCalm = TooManyRequests # rubocop:disable ConstantName
    RateLimited = TooManyRequests # rubocop:disable ConstantName
  end
end

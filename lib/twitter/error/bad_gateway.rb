require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 502
    class BadGateway < Twitter::Error; end
  end
end

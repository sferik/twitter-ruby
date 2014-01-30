require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 503
    class ServiceUnavailable < Twitter::Error; end
  end
end

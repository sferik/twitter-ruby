require 'twitter/error'

module Twitter
  # Raised when Twitter returns the HTTP status code 503
  class Error::ServiceUnavailable < Twitter::Error
  end
end

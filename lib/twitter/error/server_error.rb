require 'twitter/error'

module Twitter
  # Raised when Twitter returns a 5xx HTTP status code
  class Error::ServerError < Twitter::Error
  end
end

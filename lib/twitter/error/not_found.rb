require 'twitter/error'

module Twitter
  # Raised when Twitter returns the HTTP status code 404
  class Error::NotFound < Twitter::Error
  end
end

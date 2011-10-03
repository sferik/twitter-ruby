require 'twitter/error'

module Twitter
  # Raised when Twitter returns the HTTP status code 500
  class Error::InternalServerError < Twitter::Error
  end
end

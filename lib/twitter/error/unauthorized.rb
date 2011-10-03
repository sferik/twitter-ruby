require 'twitter/error'

module Twitter
  # Raised when Twitter returns the HTTP status code 401
  class Error::Unauthorized < Twitter::Error
  end
end

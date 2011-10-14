require 'twitter/error/client_error'

module Twitter
  # Raised when Twitter returns the HTTP status code 404
  class Error::NotFound < Twitter::Error::ClientError
  end
end

require 'twitter/error/client_error'

module Twitter
  # Raised when Twitter returns the HTTP status code 401
  class Error::Unauthorized < Twitter::Error::ClientError
  end
end

require 'twitter/error/client_error'

module Twitter
  # Raised when Twitter returns the HTTP status code 403
  class Error::Forbidden < Twitter::Error::ClientError
  end
end

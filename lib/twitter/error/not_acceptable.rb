require 'twitter/error/client_error'

module Twitter
  # Raised when Twitter returns the HTTP status code 406
  class Error::NotAcceptable < Twitter::Error::ClientError
  end
end

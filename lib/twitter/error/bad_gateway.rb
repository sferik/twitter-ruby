require 'twitter/error/server_error'

module Twitter
  # Raised when Twitter returns the HTTP status code 502
  class Error::BadGateway < Twitter::Error::ServerError
  end
end

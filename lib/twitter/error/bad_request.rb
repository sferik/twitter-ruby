require 'twitter/error/client_error'

module Twitter
  # Raised when Twitter returns the HTTP status code 400
  class Error::BadRequest < Twitter::Error::ClientError
  end
end

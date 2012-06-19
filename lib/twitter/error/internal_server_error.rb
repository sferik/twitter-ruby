require 'twitter/error/server_error'

module Twitter
  module Error
    # Raised when Twitter returns the HTTP status code 500
    class InternalServerError < Twitter::Error::ServerError
    end
  end
end

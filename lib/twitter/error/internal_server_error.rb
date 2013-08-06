require 'twitter/error/server_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 500
    class InternalServerError < Twitter::Error::ServerError
      HTTP_STATUS_CODE = 500
    end
  end
end

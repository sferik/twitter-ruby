require 'twitter/error/client_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 400
    class BadRequest < Twitter::Error::ClientError
      HTTP_STATUS_CODE = 400
    end
  end
end

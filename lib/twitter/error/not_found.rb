require 'twitter/error/client_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 404
    class NotFound < Twitter::Error::ClientError
      HTTP_STATUS_CODE = 404
    end
  end
end

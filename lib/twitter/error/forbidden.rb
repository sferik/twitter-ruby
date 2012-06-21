require 'twitter/error/client_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 403
    class Forbidden < Twitter::Error::ClientError
      HTTP_STATUS_CODE = 403
    end
  end
end

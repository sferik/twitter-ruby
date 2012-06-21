require 'twitter/error/client_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 401
    class Unauthorized < Twitter::Error::ClientError
      HTTP_STATUS_CODE = 401
    end
  end
end

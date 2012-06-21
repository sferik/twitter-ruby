require 'twitter/error/client_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 406
    class NotAcceptable < Twitter::Error::ClientError
      HTTP_STATUS_CODE = 406
    end
  end
end

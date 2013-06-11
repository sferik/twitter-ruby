require 'twitter/error/client_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 422
    class UnprocessableEntity < Twitter::Error::ClientError
      HTTP_STATUS_CODE = 422
    end
  end
end

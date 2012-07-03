require 'twitter/error/client_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 420
    class EnhanceYourCalm < Twitter::Error::ClientError
      HTTP_STATUS_CODE = 420
    end
  end
end

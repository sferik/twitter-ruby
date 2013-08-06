require 'twitter/error/server_error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 504
    class GatewayTimeout < Twitter::Error::ServerError
      HTTP_STATUS_CODE = 504
    end
  end
end

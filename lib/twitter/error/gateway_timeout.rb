require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 504
    class GatewayTimeout < Twitter::Error
      HTTP_STATUS_CODE = 504
    end
  end
end

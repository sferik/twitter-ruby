require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 504
    class GatewayTimeout < Twitter::Error; end
  end
end

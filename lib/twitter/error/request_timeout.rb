require 'twitter/error'

module Twitter
  class Error
    # Raised when the Faraday connection times out
    class RequestTimeout < Twitter::Error; end
  end
end

require 'twitter/error'

module Twitter
  class Error
    # Raised when the Faraday connection times out
    class RequestTimeout < Twitter::Error
      HTTP_STATUS_CODE = 408
    end
  end
end

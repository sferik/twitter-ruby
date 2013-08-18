require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 502
    class BadGateway < Twitter::Error
      HTTP_STATUS_CODE = 502
    end
  end
end

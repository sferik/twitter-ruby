require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 401
    class Unauthorized < Twitter::Error
      HTTP_STATUS_CODE = 401
    end
  end
end

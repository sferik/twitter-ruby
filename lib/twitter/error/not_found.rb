require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 404
    class NotFound < Twitter::Error
      HTTP_STATUS_CODE = 404
    end
  end
end

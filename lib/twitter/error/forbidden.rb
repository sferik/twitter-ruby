require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 403
    class Forbidden < Twitter::Error
      HTTP_STATUS_CODE = 403
    end
  end
end

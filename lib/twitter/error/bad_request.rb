require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 400
    class BadRequest < Twitter::Error
      HTTP_STATUS_CODE = 400
    end
  end
end

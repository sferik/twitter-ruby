require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 406
    class NotAcceptable < Twitter::Error
      HTTP_STATUS_CODE = 406
    end
  end
end

require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 406
    class NotAcceptable < Twitter::Error; end
  end
end

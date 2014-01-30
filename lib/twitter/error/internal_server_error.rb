require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 500
    class InternalServerError < Twitter::Error; end
  end
end

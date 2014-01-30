require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 404
    class NotFound < Twitter::Error; end
  end
end

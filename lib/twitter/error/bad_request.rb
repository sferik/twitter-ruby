require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 400
    class BadRequest < Twitter::Error; end
  end
end

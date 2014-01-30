require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 403
    class Forbidden < Twitter::Error; end
  end
end

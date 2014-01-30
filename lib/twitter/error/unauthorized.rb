require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 401
    class Unauthorized < Twitter::Error; end
  end
end

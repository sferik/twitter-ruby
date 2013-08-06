require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns a 5xx HTTP status code
    class ServerError < Twitter::Error
    end
  end
end

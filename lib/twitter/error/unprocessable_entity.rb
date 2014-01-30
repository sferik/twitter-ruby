require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns the HTTP status code 422
    class UnprocessableEntity < Twitter::Error; end
  end
end

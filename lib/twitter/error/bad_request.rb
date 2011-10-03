require 'twitter/error'

module Twitter
  # Raised when Twitter returns the HTTP status code 400
  class Error::BadRequest < Twitter::Error
  end
end

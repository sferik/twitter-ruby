require 'twitter/error'

module Twitter
  # Raised when Twitter returns the HTTP status code 406
  class Error::NotAcceptable < Twitter::Error
  end
end

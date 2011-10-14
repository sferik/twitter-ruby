require 'twitter/error'

module Twitter
  # Raised when Twitter returns a 4xx HTTP status code
  class Error::ClientError < Twitter::Error
  end
end

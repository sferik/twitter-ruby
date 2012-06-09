require 'twitter/error'

module Twitter
  # Raised when Twitter returns a 4xx HTTP status code or there's an error in Faraday
  class Error::ClientError < Twitter::Error
  end
end

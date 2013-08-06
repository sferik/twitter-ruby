require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns a 4xx HTTP status code or there's an error in Faraday
    class ClientError < Twitter::Error
    end
  end
end

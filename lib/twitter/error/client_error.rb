require 'twitter/error'

module Twitter
  module Error
    # Raised when Twitter returns a 4xx HTTP status code or there's an error in Faraday
    class ClientError < StandardError
      include Twitter::Error
    end
  end
end

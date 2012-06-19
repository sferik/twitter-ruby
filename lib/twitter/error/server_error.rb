require 'twitter/error'

module Twitter
  module Error
    # Raised when Twitter returns a 5xx HTTP status code
    class ServerError < StandardError
      include Twitter::Error
    end
  end
end

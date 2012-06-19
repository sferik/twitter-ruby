require 'twitter/error/server_error'

module Twitter
  module Error
    # Raised when Twitter returns the HTTP status code 503
    class ServiceUnavailable < Twitter::Error::ServerError
    end
  end
end

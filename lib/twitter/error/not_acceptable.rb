require 'twitter/error/client_error'

module Twitter
  module Error
    # Raised when Twitter returns the HTTP status code 406
    class NotAcceptable < Twitter::Error::ClientError
    end
  end
end

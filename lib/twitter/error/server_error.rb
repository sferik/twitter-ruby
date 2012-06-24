require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns a 5xx HTTP status code
    class ServerError < Twitter::Error
      MESSAGE = "Server Error"

      # Initializes a new ServerError object
      #
      # @param message [String]
      # @return [Twitter::Error::ServerError]
      def initialize(message=nil)
        message ||= self.class.const_get(:MESSAGE)
        super(message)
      end

    end
  end
end

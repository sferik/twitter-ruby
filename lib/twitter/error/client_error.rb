require 'twitter/error'

module Twitter
  class Error
    # Raised when Twitter returns a 4xx HTTP status code or there's an error in Faraday
    class ClientError < Twitter::Error

      # Create a new error from an HTTP environment
      #
      # @param response [Hash]
      # @return [Twitter::Error]
      def self.from_response(response={})
        error, code = parse_error(response[:body])
        new(error, response[:response_headers], code)
      end
    end
  end
end

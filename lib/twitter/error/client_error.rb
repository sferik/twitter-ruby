require 'twitter/error'

module Twitter
  module Error
    # Raised when Twitter returns a 4xx HTTP status code or there's an error in Faraday
    class ClientError < StandardError
      include Twitter::Error

      # Create a new error from a HTTP environment
      #
      # @param env [Hash]
      # @return [Twitter::Error]
      def self.from_env(env)
        new(error_body(env[:message]), env[:response_headers])
      end

    private

      def self.error_body(message)
        if message.nil?
          ''
        elsif message['error']
          message['error']
        elsif message['errors']
          first = Array(message['errors']).first
          if first.kind_of?(Hash)
            first['message'].chomp
          else
            first.chomp
          end
        end
      end

    end
  end
end

require "twitter/client"
require "twitter/rest/api"
require "twitter/rest/request"
require "twitter/rest/utils"

module Twitter
  module REST
    # REST API client for Twitter
    class Client < Twitter::Client
      include Twitter::REST::API

      # The bearer token for application-only authentication
      #
      # @api public
      # @example
      #   client.bearer_token = "AAAA..."
      # @return [String]
      attr_accessor :bearer_token

      # Returns true if a bearer token is set
      #
      # @api public
      # @example
      #   client.bearer_token?
      # @return [Boolean]
      def bearer_token?
        !!bearer_token
      end

      # Returns true if credentials are configured
      #
      # @api public
      # @example
      #   client.credentials?
      # @return [Boolean]
      def credentials?
        super || bearer_token?
      end
    end
  end
end

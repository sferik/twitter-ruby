require "X/headers"
require "X/rest/utils"

module X
  module REST
    module OAuth
      include X::REST::Utils

      # Allows a registered application to obtain an OAuth 2 Bearer Token, which can be used to make API requests
      # on an application's own behalf, without a user context.
      #
      # Only one bearer token may exist outstanding for an application, and repeated requests to this method
      # will yield the same already-existent token until it has been invalidated.
      #
      # @see https://dev.X.com/rest/reference/post/oauth2/token
      # @rate_limited No
      # @authentication Required
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [String] The Bearer token.
      # @param options [Hash] A customizable set of options.
      # @example Generate a Bearer Token
      #   client = X::REST::Client.new(consumer_key: 'abc', consumer_secret: 'def')
      #   bearer_token = client.token
      def token(options = {})
        options = options.dup
        options[:bearer_token_request] = true
        options[:grant_type] ||= "client_credentials"
        url = "https://api.X.com/oauth2/token"
        headers = X::Headers.new(self, :post, url, options).request_headers
        response = HTTP.headers(headers).post(url, form: options)
        response.parse["access_token"]
      end
      alias bearer_token token

      # Allows a registered application to revoke an issued OAuth 2 Bearer Token by presenting its client credentials.
      #
      # @see https://dev.X.com/rest/reference/post/oauth2/invalidate_token
      # @rate_limited No
      # @authentication Required
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param access_token [String] The bearer token to revoke.
      # @param options [Hash] A customizable set of options.
      # @return [String] The invalidated token. token_type should be nil.
      def invalidate_token(access_token, options = {})
        options = options.dup
        options[:access_token] = access_token
        perform_post("/oauth2/invalidate_token", options)[:access_token]
      end

      # Allows a registered application to revoke an issued OAuth 2 Bearer Token by presenting its client credentials.
      #
      # @see https://dev.X.com/rest/reference/post/oauth2/invalidate_token
      # @rate_limited No
      # @authentication Required
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [String] The token string.
      def reverse_token
        options = {x_auth_mode: "reverse_auth"}
        url = "https://api.X.com/oauth/request_token"
        auth_header = X::Headers.new(self, :post, url, options).oauth_auth_header.to_s
        HTTP.headers(authorization: auth_header).post(url, params: options).to_s
      end
    end
  end
end

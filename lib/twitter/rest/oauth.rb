require "twitter/headers"
require "twitter/rest/utils"

module Twitter
  module REST
    # Methods for OAuth authentication
    module OAuth
      include Twitter::REST::Utils

      # Obtains an OAuth 2 Bearer Token for application-only auth
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/oauth2/token
      # @rate_limited No
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.token
      # @return [String] The Bearer token.
      # @param options [Hash] A customizable set of options.
      def token(options = {})
        options = options.dup
        options[:bearer_token_request] = true
        options[:grant_type] ||= "client_credentials"
        url = "https://api.twitter.com/oauth2/token"
        headers = ::Twitter::Headers.new(self, :post, url, options).request_headers # steep:ignore ArgumentTypeMismatch
        response = HTTP.headers(headers).post(url, form: options) # steep:ignore NoMethod
        response.parse.fetch("access_token")
      end
      # @!method bearer_token
      #   @api public
      #   @see #token
      alias_method :bearer_token, :token

      # Revokes an issued OAuth 2 Bearer Token
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/oauth2/invalidate_token
      # @rate_limited No
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.invalidate_token('AAAA...')
      # @param access_token [String] The bearer token to revoke.
      # @param options [Hash] A customizable set of options.
      # @return [String] The invalidated token. token_type should be nil.
      def invalidate_token(access_token, options = {})
        options = options.dup
        options[:access_token] = access_token
        perform_post("/oauth2/invalidate_token", options).fetch(:access_token)
      end

      # Returns a reverse auth token for mobile applications
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/oauth2/invalidate_token
      # @rate_limited No
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.reverse_token
      # @return [String] The token string.
      def reverse_token
        options = {x_auth_mode: "reverse_auth"}
        url = "https://api.twitter.com/oauth/request_token"
        auth_header = ::Twitter::Headers.new(self, :post, url, options).oauth_auth_header.to_s # steep:ignore ArgumentTypeMismatch
        HTTP.headers(authorization: auth_header).post(url, params: options).to_s # steep:ignore NoMethod
      end
    end
  end
end

require 'twitter/headers'
require 'twitter/rest/utils'
require 'twitter/rest/response/parse_error_json'
require 'twitter/token'

module Twitter
  module REST
    module OAuth
      include Twitter::REST::Utils

      # Allows a registered application to obtain an OAuth 2 Bearer Token, which can be used to make API requests
      # on an application's own behalf, without a user context.
      #
      # Only one bearer token may exist outstanding for an application, and repeated requests to this method
      # will yield the same already-existent token until it has been invalidated.
      #
      # @see https://dev.twitter.com/rest/reference/post/oauth2/token
      # @rate_limited No
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Token] The Bearer Token. token_type should be 'bearer'.
      # @param options [Hash] A customizable set of options.
      # @example Generate a Bearer Token
      #   client = Twitter::REST::Client.new(:consumer_key => "abc", :consumer_secret => 'def')
      #   bearer_token = client.token
      def token(options = {})
        options[:bearer_token_request] = true
        options[:grant_type] ||= 'client_credentials'
        perform_post_with_object('/oauth2/token', options, Twitter::Token)
      end
      alias_method :bearer_token, :token

      # Allows a registered application to revoke an issued OAuth 2 Bearer Token by presenting its client credentials.
      #
      # @see https://dev.twitter.com/rest/reference/post/oauth2/invalidate_token
      # @rate_limited No
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param access_token [String, Twitter::Token] The bearer token to revoke.
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::Token] The invalidated token. token_type should be nil.
      def invalidate_token(access_token, options = {})
        access_token = access_token.access_token if access_token.is_a?(Twitter::Token)
        options[:access_token] = access_token
        perform_post_with_object('/oauth2/invalidate_token', options, Twitter::Token)
      end

      # Allows a registered application to revoke an issued OAuth 2 Bearer Token by presenting its client credentials.
      #
      # @see https://dev.twitter.com/rest/reference/post/oauth2/invalidate_token
      # @rate_limited No
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [String] The token string.
      def reverse_token
        conn = connection.dup
        conn.builder.swap(4, Twitter::REST::Response::ParseErrorJson)
        response = conn.post('/oauth/request_token?x_auth_mode=reverse_auth') do |request|
          request.headers[:authorization] = Twitter::Headers.new(self, :post, 'https://api.twitter.com/oauth/request_token', :x_auth_mode => 'reverse_auth').oauth_auth_header.to_s
        end
        response.body
      end
    end
  end
end

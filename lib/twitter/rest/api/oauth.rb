require 'twitter/rest/api/utils'
require 'twitter/token'
require 'twitter/rest/response/parse_error_json'

module Twitter
  module REST
    module API
      module OAuth
        include Twitter::REST::API::Utils

        # Allows a registered application to obtain an OAuth 2 Bearer Token, which can be used to make API requests
        # on an application's own behalf, without a user context.
        #
        # Only one bearer token may exist outstanding for an application, and repeated requests to this method
        # will yield the same already-existent token until it has been invalidated.
        #
        # @see https://dev.twitter.com/docs/api/1.1/post/oauth2/token
        # @rate_limited No
        # @authentication Required
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @return [Twitter::Token] The Bearer Token. token_type should be 'bearer'.
        # @example Generate a Bearer Token
        #   client = Twitter::REST::Client.new(:consumer_key => "abc", :consumer_secret => 'def')
        #   bearer_token = client.token
        def token
          object_from_response(Twitter::Token, :post, "/oauth2/token", :grant_type => "client_credentials", :bearer_token_request => true)
        end
        alias bearer_token token

        # Allows a registered application to revoke an issued OAuth 2 Bearer Token by presenting its client credentials.
        #
        # @see https://dev.twitter.com/docs/api/1.1/post/oauth2/invalidate_token
        # @rate_limited No
        # @authentication Required
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @param access_token [String, Twitter::Token] The bearer token to revoke.
        # @return [Twitter::Token] The invalidated token. token_type should be nil.
        def invalidate_token(access_token)
          access_token = access_token.access_token if access_token.is_a?(Twitter::Token)
          object_from_response(Twitter::Token, :post, "/oauth2/invalidate_token", :access_token => access_token)
        end

        def reverse_token
          conn = connection.dup
          conn.builder.swap 4, Twitter::REST::Response::ParseErrorJson
          conn.post('/oauth/request_token?x_auth_mode=reverse_auth') do |request|
            request.headers[:authorization] = oauth_auth_header(:post, 'https://api.twitter.com/oauth/request_token', :x_auth_mode => 'reverse_auth').to_s
          end.body
        end

      end
    end
  end
end

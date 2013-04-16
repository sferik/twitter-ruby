require 'twitter/api/utils'
require 'twitter/token'

module Twitter
  module API
    module OAuth
      include Twitter::API::Utils
      def token
        object_from_response(Twitter::Token, :bearer_request, "/oauth2/token", :grant_type => "client_credentials")
      end
      # Allows a registered application to revoke an issued OAuth 2 Bearer Token by presenting its client credentials.
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/oauth2/invalidate_token
      # @rate_limited No
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param access_token [String] The value of the bearer token to revoke.
      # @return [Twitter::Token] The invalidated token. token_type should be nil.
      # @example Revoke a token
      #   Twitter.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")
      def invalidate_token(access_token)
        object_from_response(Twitter::Token, :post, "/oauth2/invalidate_token", :access_token => access_token)
      end

    private
      def bearer_request(path, params={})
        connection.send(:post, path, params) do |request|
          request.headers[:accept] = "*/*"
          request.headers[:authorization] = "Basic #{encoded_bearer_token_credentials}"
          request.headers[:content_type] = "application/x-www-form-urlencoded; charset=UTF-8"
        end.env
      rescue Faraday::Error::ClientError
        raise Twitter::Error::ClientError
      rescue MultiJson::DecodeError
        raise Twitter::Error::DecodeError
      end
    end
  end
end
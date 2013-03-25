require 'twitter/api/utils'
require 'twitter/token'

module Twitter
  module API
    module OAuth
      include Twitter::API::Utils

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
    end
  end
end
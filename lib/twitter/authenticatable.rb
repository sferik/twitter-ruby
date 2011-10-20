module Twitter
  module Authenticatable

    # Credentials hash
    #
    # @return [Hash]
    def credentials
      {
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret,
        :token => oauth_token,
        :token_secret => oauth_token_secret,
      }
    end

    # Check whether credentials are present
    #
    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

  end
end

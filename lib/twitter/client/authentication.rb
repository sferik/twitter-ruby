module Twitter
  class Client
    module Authentication
      private
        def authentication
          {
            :consumer_key => consumer_key,
            :consumer_secret => consumer_secret,
            :token => oauth_token,
            :token_secret => oauth_token_secret
          }
        end

        def authenticated?
          authentication.values.all?
        end
    end
  end
end

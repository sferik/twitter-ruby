module Twitter
  class Client
    module Authentication
      private
        def authenticate!(&block)
          raise Twitter::Unauthorized, 'Authentication is required.' unless authenticated?
          authenticate(&block)
        end

        def authenticate
          @authenticate = authenticated?
          if block_given?
            begin
              @persist_authenticate = true
              yield
            ensure
              reset_authenticate
            end
          end
        end

        def authenticated?
          [consumer_key, consumer_secret, access_key, access_secret].all?
        end

        def reset_authenticate
          @authenticate = nil
          @persist_authenticate = nil
        end

        def authenticate?
          !!@authenticate
        end

        def persist_authenticate?
          !!@persist_authenticate
        end

        def authentication
          {
            :consumer_key => consumer_key,
            :consumer_secret => consumer_secret,
            :token => access_key,
            :token_secret => access_secret
          }
        end

        def request(*args)
          begin
            super
          ensure
            reset_authenticate unless persist_authenticate?
          end
        end
    end
  end
end

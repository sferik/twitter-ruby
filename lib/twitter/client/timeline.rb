module Twitter
  class Client
    module Timeline
      def public_timeline(options={})
        get('statuses/public_timeline', options)
      end

      def home_timeline(options={})
        authenticate! do
          get('statuses/home_timeline', options)
        end
      end

      def friends_timeline(options={})
        authenticate! do
          get('statuses/friends_timeline', options)
        end
      end

      def user_timeline(options={})
        authenticate do
          get('statuses/user_timeline', options)
        end
      end

      def mentions(options={})
        authenticate! do
          get('statuses/mentions', options)
        end
      end

      def retweeted_by_me(options={})
        authenticate! do
          get('statuses/retweeted_by_me', options)
        end
      end

      def retweeted_to_me(options={})
        authenticate! do
          get('statuses/retweeted_to_me', options)
        end
      end

      def retweets_of_me(options={})
        authenticate! do
          get('statuses/retweets_of_me', options)
        end
      end
    end
  end
end

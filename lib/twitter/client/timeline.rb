module Twitter
  class Client
    module Timeline
      def public_timeline(options={})
        response = get('statuses/public_timeline', options)
      end

      def home_timeline(options={})
        response = get('statuses/home_timeline', options)
      end

      def friends_timeline(options={})
        response = get('statuses/friends_timeline', options)
      end

      def user_timeline(user, options={})
        merge_user_into_options!(user, options)
        response = get('statuses/user_timeline', options)
      end

      def mentions(options={})
        response = get('statuses/mentions', options)
      end

      def retweeted_by_me(options={})
        response = get('statuses/retweeted_by_me', options)
      end

      def retweeted_to_me(options={})
        response = get('statuses/retweeted_to_me', options)
      end

      def retweets_of_me(options={})
        response = get('statuses/retweets_of_me', options)
      end
    end
  end
end

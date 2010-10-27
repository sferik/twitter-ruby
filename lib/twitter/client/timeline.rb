module Twitter
  class Client
    module Timeline
      def public_timeline(options={})
        response = get('statuses/public_timeline', options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      def home_timeline(options={})
        response = get('statuses/home_timeline', options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      def friends_timeline(options={})
        response = get('statuses/friends_timeline', options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      def user_timeline(user, options={})
        merge_user_into_options!(user, options)
        response = get('statuses/user_timeline', options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      def mentions(options={})
        response = get('statuses/mentions', options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      def retweeted_by_me(options={})
        response = get('statuses/retweeted_by_me', options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      def retweeted_to_me(options={})
        response = get('statuses/retweeted_to_me', options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end

      def retweets_of_me(options={})
        response = get('statuses/retweets_of_me', options)
        format.to_s.downcase == 'xml' ? response['statuses'] : response
      end
    end
  end
end

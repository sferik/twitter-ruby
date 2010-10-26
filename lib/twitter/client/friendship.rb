module Twitter
  class Client
    module Friendship
      def friendship_create(user, *args)
        merge_user_into_options!(user, options)
        options = args.last.is_a?(Hash) ? args.pop : {}
        follow = args.first || false
        response = post('friendships/create', options.merge(:follow => follow))
      end

      def friendship_destroy(user, options={})
        merge_user_into_options!(user, options)
        response = delete('friendships/destroy', options)
      end

      def friendship_exists?(user_a, user_b, options={})
        response = get('friendships/exists', options.merge(:user_a => user_a, :user_b => user_b))
        format == :xml ? !%w(0 false).include?(response['friends']) : response
      end

      def friendship(options={})
        response = get('friendships/show', options)
      end

      alias :friendship_show :friendship

      def friendships_incoming(options={})
        response = get('friendships/incoming', options)
      end

      def friendships_outgoing(options={})
        response = get('friendships/outgoing', options)
      end
    end
  end
end

module Twitter
  class Client
    module FriendsAndFollowers
      def friend_ids(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.first
        merge_user_into_options!(user, options)
        response = get('friends/ids', options)
        format.to_s.downcase == 'xml' ? response['ids']['id'].map{|id| id.to_i} : response
      end

      def follower_ids(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.first
        merge_user_into_options!(user, options)
        response = get('followers/ids', options)
        format.to_s.downcase == 'xml' ? response['ids']['id'].map{|id| id.to_i} : response
      end
    end
  end
end

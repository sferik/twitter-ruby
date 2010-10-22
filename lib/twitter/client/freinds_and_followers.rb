module Twitter
  class Client
    module FriendsAndFollowers
      def friend_ids(user, options={})
        merge_user_into_options!(user, options)
        get('friends/ids', options)
      end

      def follower_ids(user, options={})
        merge_user_into_options!(user, options)
        get('followers/ids', options)
      end
    end
  end
end

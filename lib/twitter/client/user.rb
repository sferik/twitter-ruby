module Twitter
  class Client
    module User
      def user(user, options={})
        merge_user_into_options!(user, options)
        get('users/show', options)
      end

      def users(users, options={})
        merge_users_into_options!(Array(users), options)
        get('users/lookup', options)
      end

      def user_search(query, options={})
        get('users/search', options.merge(:q => query))
      end

      def suggestions(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        category = args.first
        get(['users/suggestions', category].compact.join('/'), options)
      end

      def profile_image(screen_name, options={})
        get("users/profile_image/#{screen_name}", options, true).headers['location']
      end

      def friends(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.first
        if user
          merge_user_into_options!(user, options)
          get('statuses/friends', options)
        else
          authenticate! do
            get('statuses/friends', options)
          end
        end
      end

      def followers(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.first
        if user
          merge_user_into_options!(user, options)
          get('statuses/followers', options)
        else
          authenticate! do
            get('statuses/followers', options)
          end
        end
      end
    end
  end
end

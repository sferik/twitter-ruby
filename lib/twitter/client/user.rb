module Twitter
  class Client
    module User
      # Returns extended information of a given user
      #
      # @format :json, :xml
      # @authenticated false
      # @rate_limited true
      # @param user [String, Integer] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The requested user object.
      # @see http://dev.twitter.com/doc/get/users/show
      # @example Return extended information for @sferik
      #   Twitter.user("sferik")
      #   Twitter.user(7505382)  # Same as above
      def user(user, options={})
        merge_user_into_options!(user, options)
        response = get('users/show', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Returns extended information of a given user
      #
      # @format :json, :xml
      # @authenticated false
      # @rate_limited true
      # @param user [String, Integer] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The requested user object.
      # @see http://dev.twitter.com/doc/get/users/lookup
      # @example Return extended information for @sferik
      #   Twitter.user("sferik", "pengwynn")
      #   Twitter.user("sferik", 14100886)   # Same as above
      #   Twitter.user(7505382, 14100886)    # Same as above
      def users(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        users = args
        merge_users_into_options!(Array(users), options)
        response = get('users/lookup', options)
        format.to_s.downcase == 'xml' ? response['users'] : response
      end

      def user_search(query, options={})
        response = get('users/search', options.merge(:q => query))
        format.to_s.downcase == 'xml' ? response['users'] : response
      end

      def suggestions(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        category = args.first
        response = get(['users/suggestions', category].compact.join('/'), options)
        xml_key = category ? 'category' : 'suggestions'
        format.to_s.downcase == 'xml' ? response[xml_key] : response
      end

      def profile_image(screen_name, options={})
        get("users/profile_image/#{screen_name}", options, true).headers['location']
      end

      def friends(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.first
        if user
          merge_user_into_options!(user, options)
          response = get('statuses/friends', options)
        else
          response = get('statuses/friends', options)
        end
        format.to_s.downcase == 'xml' ? response['users'] : response
      end

      def followers(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.first
        if user
          merge_user_into_options!(user, options)
          response = get('statuses/followers', options)
        else
          response = get('statuses/followers', options)
        end
        format.to_s.downcase == 'xml' ? response['users'] : response
      end
    end
  end
end

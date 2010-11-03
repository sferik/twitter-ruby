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
      # @authenticated true
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

      # Returns users that match the given query
      #
      # @format :json, :xml
      # @authenticated true
      # @rate_limited true
      # @param query [String] The search query to run against people search.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :per_page The number of people to retrieve. Maxiumum of 20 allowed per page.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [String] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/users/search
      # @example Return users that match "Erik Michaels-Ober"
      #   Twitter.user_search("Erik Michaels-Ober")
      def user_search(query, options={})
        response = get('users/search', options.merge(:q => query))
        format.to_s.downcase == 'xml' ? response['users'] : response
      end

      # Returns the list of suggested user categories or users in a given category
      #
      # @format :json, :xml
      # @authenticated false
      # @rate_limited true
      # @param slug [String] The short name of list or a category.
      # @param options [Hash] A customizable set of options.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/users/suggestions
      # @see http://dev.twitter.com/doc/get/users/suggestions/:slug
      # @example
      #   Twitter.suggestions               # Return the list of suggested user categories
      #   Twitter.suggestions("art-design") # Return the users in the Art & Design category
      def suggestions(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        slug = args.first
        response = get(['users/suggestions', slug].compact.join('/'), options)
        xml_key = slug ? 'category' : 'suggestions'
        format.to_s.downcase == 'xml' ? response[xml_key] : response
      end

      # Access the profile image in various sizes for the user with the indicated screen name
      #
      # @format :json, :xml
      # @authenticated false
      # @rate_limited false
      # @param screen_name [String] The screen name of the user for whom to return results for.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :size ('normal') Specifies the size of image to fetch. Valid options include: 'bigger' (73px by 73px), 'normal' (48px by 48px), and 'mini' (24px by 24px).
      # @return [String] The URL for the requested user's profile image.
      # @see http://dev.twitter.com/doc/get/users/profile_image/:screen_name
      # @example Return the URL for the 24px by 24px version of @sferik's profile image
      #   Twitter.profile_image("sferik", :size => 'mini')
      def profile_image(screen_name, options={})
        clean_screen_name!(screen_name)
        get("users/profile_image/#{screen_name}", options, true).headers['location']
      end

      # Returns a user's friends
      #
      # @format :json, :xml
      # @authenticated false unless requesting it from a protected user; if getting this data of a protected user, you must auth (and be allowed to see that user).
      # @rate_limited true
      # @param user [String, Integer] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :cursor Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @option options [String] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/statuses/friends
      # @example Return the @sferik's friends
      #   Twitter.freinds("sferik")
      #   Twitter.friends(7505382)  # Same as above
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

      # Returns a user's followers
      #
      # @format :json, :xml
      # @authenticated false unless requesting it from a protected user; if getting this data of a protected user, you must auth (and be allowed to see that user).
      # @rate_limited true
      # @param user [String, Integer] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :cursor Breaks the results into pages. This is recommended for users who are followed by many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @option options [String] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/statuses/followers
      # @example Return the @sferik's followers
      #   Twitter.followers("sferik")
      #   Twitter.followers(7505382)  # Same as above
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

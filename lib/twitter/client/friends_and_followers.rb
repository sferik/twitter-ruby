require 'twitter/core_ext/hash'
require 'twitter/cursor'
require 'twitter/relationship'
require 'twitter/user'

module Twitter
  class Client
    # Defines methods related to friends and followers
    module FriendsAndFollowers

      # @see https://dev.twitter.com/docs/api/1/get/followers/ids
      # @rate_limited Yes
      # @requires_authentication No unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @overload follower_ids(options={})
      #   Returns an array of numeric IDs for every user following the authenticated user
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @example Return the authenticated user's followers' IDs
      #     Twitter.follower_ids
      # @overload follower_ids(user, options={})
      #   Returns an array of numeric IDs for every user following the specified user
      #
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @example Return @sferik's followers' IDs
      #     Twitter.follower_ids('sferik')
      #     Twitter.follower_ids(7505382)  # Same as above
      def follower_ids(*args)
        options = {:cursor => -1}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        user = args.first
        options.merge_user!(user)
        cursor = get("/1/followers/ids.json", options)
        Twitter::Cursor.new(cursor, 'ids')
      end

      # @see https://dev.twitter.com/docs/api/1/get/friends/ids
      # @rate_limited Yes
      # @requires_authentication No unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @overload friend_ids(options={})
      #   Returns an array of numeric IDs for every user the authenticated user is following
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @example Return the authenticated user's friends' IDs
      #     Twitter.friend_ids
      # @overload friend_ids(user, options={})
      #   Returns an array of numeric IDs for every user the specified user is following
      #
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @return [Twitter::Cursor]
      #   @example Return @sferik's friends' IDs
      #     Twitter.friend_ids('sferik')
      #     Twitter.friend_ids(7505382)  # Same as above
      def friend_ids(*args)
        options = {:cursor => -1}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        user = args.first
        options.merge_user!(user)
        cursor = get("/1/friends/ids.json", options)
        Twitter::Cursor.new(cursor, 'ids')
      end

      # Test for the existence of friendship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/exists
      # @note Consider using {Twitter::Client::FriendsAndFollowers#friendship} instead of this method.
      # @rate_limited Yes
      # @requires_authentication No unless user_a or user_b is protected
      # @param user_a [Integer, String] The ID or screen_name of the subject user.
      # @param user_b [Integer, String] The ID or screen_name of the user to test for following.
      # @param options [Hash] A customizable set of options.
      # @return [Boolean] true if user_a follows user_b, otherwise false.
      # @example Return true if @sferik follows @pengwynn
      #   Twitter.friendship?('sferik', 'pengwynn')
      def friendship?(user_a, user_b, options={})
        get("/1/friendships/exists.json", options.merge(:user_a => user_a, :user_b => user_b))
      end

      # Returns an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/incoming
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @return [Twitter::Cursor]
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #   Twitter.friendships_incoming
      def friendships_incoming(options={})
        options = {:cursor => -1}.merge(options)
        cursor = get("/1/friendships/incoming.json", options)
        Twitter::Cursor.new(cursor, 'ids')
      end

      # Returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/outgoing
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @return [Twitter::Cursor]
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #   Twitter.friendships_outgoing
      def friendships_outgoing(options={})
        options = {:cursor => -1}.merge(options)
        cursor = get("/1/friendships/outgoing.json", options)
        Twitter::Cursor.new(cursor, 'ids')
      end

      # Returns detailed information about the relationship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/show
      # @rate_limited Yes
      # @requires_authentication No
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::Relationship]
      # @example Return the relationship between @sferik and @pengwynn
      #   Twitter.friendship('sferik', 'pengwynn')
      #   Twitter.friendship(7505382, 14100886)
      def friendship(source, target, options={})
        case source
        when Integer
          options[:source_id] = source
        when String
          options[:source_screen_name] = source
        end
        case target
        when Integer
          options[:target_id] = target
        when String
          options[:target_screen_name] = target
        end
        relationship = get("/1/friendships/show.json", options)['relationship']
        Twitter::Relationship.new(relationship)
      end
      alias :friendship_show :friendship
      alias :relationship :friendship

      # Allows the authenticating user to follow the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/create
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :follow (false) Enable notifications for the target user.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Twitter::User] The followed user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Follow @sferik
      #   Twitter.follow('sferik')
      def follow(user, options={})
        options.merge_user!(user)
        # Twitter always turns on notifications if the "follow" option is present, even if it's set to false
        # so only send follow if it's true
        options.merge!(:follow => true) if options.delete(:follow)
        user = post("/1/friendships/create.json", options)
        Twitter::User.new(user)
      end
      alias :friendship_create :follow

      # Allows the authenticating user to unfollow the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/destroy
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Twitter::User] The unfollowed user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Unfollow @sferik
      #   Twitter.unfollow('sferik')
      def unfollow(user, options={})
        options.merge_user!(user)
        user = delete("/1/friendships/destroy.json", options)
        Twitter::User.new(user)
      end
      alias :friendship_destroy :unfollow

      # Returns the relationship of the authenticating user to the comma separated list of up to 100 screen_names or user_ids provided. Values for connections can be: following, following_requested, followed_by, none.
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/lookup
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::Relationship]
      # @overload friendships(*users, options={})
      #   @param users [Array<Integer, String>, Set<Integer, String>] Twitter user IDs or screen names.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet
      #   @return [Array<Twitter::User>] The requested users.
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return extended information for @sferik and @pengwynn
      #     Twitter.friendships('sferik', 'pengwynn')
      #     Twitter.friendships('sferik', 14100886)   # Same as above
      #     Twitter.friendships(7505382, 14100886)    # Same as above
      def friendships(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        users = args
        options.merge_users!(Array(users))
        get("/1/friendships/lookup.json", options).map do |user|
          Twitter::User.new(user)
        end
      end

      # Allows one to enable or disable retweets and device notifications from the specified user.
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/update
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :device Enable/disable device notifications from the target user.
      # @option options [Boolean] :retweets Enable/disable retweets from the target user.
      # @return [Twitter::Relationship]
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Enable rewteets and devise notifications for @sferik
      #   Twitter.friendship_update('sferik', :device => true, :retweets => true)
      def friendship_update(user, options={})
        options.merge_user!(user)
        relationship = post("/1/friendships/update.json", options)['relationship']
        Twitter::Relationship.new(relationship)
      end

      # Returns an array of user_ids that the currently authenticated user does not want to see retweets from.
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/no_retweet_ids
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param user [Integer, String] Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :stringify_ids Many programming environments will not consume our ids due to their size. Provide this option to have ids returned as strings instead. Read more about Twitter IDs, JSON and Snowflake.
      # @return [Array<Integer>]
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Enable rewteets and devise notifications for @sferik
      #   Twitter.no_retweet_ids
      def no_retweet_ids(options={})
        get("/1/friendships/no_retweet_ids.json", options, :phoenix => true)
      end

      # Allows the authenticating user to accept the specified user's follow request
      #
      # @note Undocumented
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::User] The accepted user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Accept @sferik's follow request
      #   Twitter.accept('sferik')
      def accept(user, options={})
        options.merge_user!(user)
        user = post("/1/friendships/accept.json", options)
        Twitter::User.new(user)
      end

      # Allows the authenticating user to deny the specified user's follow request
      #
      # @note Undocumented
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::User] The denied user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Deny @sferik's follow request
      #   Twitter.deny('sferik')
      def deny(user, options={})
        options.merge_user!(user)
        user = post("/1/friendships/deny.json", options)
        Twitter::User.new(user)
      end

    end
  end
end

require 'twitter/api/utils'
require 'twitter/core_ext/array'
require 'twitter/core_ext/enumerable'
require 'twitter/core_ext/hash'
require 'twitter/cursor'
require 'twitter/error/forbidden'
require 'twitter/relationship'
require 'twitter/user'

module Twitter
  module API
    module Friendships
      include Twitter::API::Utils

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :follower_ids => true,
            :friend_ids => true,
            :friendship? => true,
            :friendships_incoming => true,
            :friendships_outgoing => true,
            :friendship => true,
            :friendship_show => true,
            :relationship => true,
            :follow => false,
            :friendship_create => false,
            :follow! => false,
            :friendship_create! => false,
            :unfollow => false,
            :friendship_destroy => false,
            :friendships => true,
            :friendship_update => true,
            :no_retweet_ids => true,
            :accept => false,
            :deny => false,
          }
        )
      end

      # @see https://dev.twitter.com/docs/api/1/get/followers/ids
      # @rate_limited Yes
      # @authentication_required No unless requesting it from a protected user
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @overload follower_ids(options={})
      #   Returns an array of numeric IDs for every user following the authenticated user
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the authenticated user's followers' IDs
      #     Twitter.follower_ids
      # @overload follower_ids(user, options={})
      #   Returns an array of numeric IDs for every user following the specified user
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return @sferik's followers' IDs
      #     Twitter.follower_ids('sferik')
      #     Twitter.follower_ids(7505382)  # Same as above
      def follower_ids(*args)
        options = {:cursor => -1}
        options.merge!(args.extract_options!)
        user = args.pop
        options.merge_user!(user)
        response = get("/1/followers/ids.json", options)
        Twitter::Cursor.from_response(response)
      end

      # @see https://dev.twitter.com/docs/api/1/get/friends/ids
      # @rate_limited Yes
      # @authentication_required No unless requesting it from a protected user
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @overload friend_ids(options={})
      #   Returns an array of numeric IDs for every user the authenticated user is following
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return the authenticated user's friends' IDs
      #     Twitter.friend_ids
      # @overload friend_ids(user, options={})
      #   Returns an array of numeric IDs for every user the specified user is following
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #   @example Return @sferik's friends' IDs
      #     Twitter.friend_ids('sferik')
      #     Twitter.friend_ids(7505382)  # Same as above
      def friend_ids(*args)
        options = {:cursor => -1}
        options.merge!(args.extract_options!)
        user = args.pop
        options.merge_user!(user)
        response = get("/1/friends/ids.json", options)
        Twitter::Cursor.from_response(response)
      end

      # Test for the existence of friendship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/exists
      # @note Consider using {Twitter::API::Friendships#friendship} instead of this method.
      # @rate_limited Yes
      # @authentication_required No unless user_a or user_b is protected
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean] true if user_a follows user_b, otherwise false.
      # @param user_a [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the subject user.
      # @param user_b [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the user to test for following.
      # @param options [Hash] A customizable set of options.
      # @example Return true if @sferik follows @pengwynn
      #   Twitter.friendship?('sferik', 'pengwynn')
      #   Twitter.friendship?('sferik', 14100886)   # Same as above
      #   Twitter.friendship?(7505382, 14100886)    # Same as above
      def friendship?(user_a, user_b, options={})
        options.merge_user!(user_a, nil, "a")
        options.merge_user!(user_b, nil, "b")
        get("/1/friendships/exists.json", options)[:body]
      end

      # Returns an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/incoming
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @example Return an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #   Twitter.friendships_incoming
      def friendships_incoming(options={})
        options = {:cursor => -1}.merge(options)
        response = get("/1/friendships/incoming.json", options)
        Twitter::Cursor.from_response(response)
      end

      # Returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/outgoing
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @example Return an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #   Twitter.friendships_outgoing
      def friendships_outgoing(options={})
        options = {:cursor => -1}.merge(options)
        response = get("/1/friendships/outgoing.json", options)
        Twitter::Cursor.from_response(response)
      end

      # Returns detailed information about the relationship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/show
      # @rate_limited Yes
      # @authentication_required No
      # @return [Twitter::Relationship]
      # @param source [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the source user.
      # @param target [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the target user.
      # @param options [Hash] A customizable set of options.
      # @example Return the relationship between @sferik and @pengwynn
      #   Twitter.friendship('sferik', 'pengwynn')
      #   Twitter.friendship('sferik', 14100886)   # Same as above
      #   Twitter.friendship(7505382, 14100886)    # Same as above
      def friendship(source, target, options={})
        options.merge_user!(source, "source")
        options[:source_id] = options.delete(:source_user_id) unless options[:source_user_id].nil?
        options.merge_user!(target, "target")
        options[:target_id] = options.delete(:target_user_id) unless options[:target_user_id].nil?
        response = get("/1/friendships/show.json", options)
        Twitter::Relationship.from_response(response)
      end
      alias friendship_show friendship
      alias relationship friendship

      # Allows the authenticating user to follow the specified users, unless they are already followed
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/create
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The followed users.
      # @overload(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Follow @sferik
      #     Twitter.follow('sferik')
      # @overload(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean] :follow (false) Enable notifications for the target user.
      def follow(*args)
        options = args.extract_options!
        # Twitter always turns on notifications if the "follow" option is present, even if it's set to false
        # so only send follow if it's true
        options.merge!(:follow => true) if options.delete(:follow)
        friend_ids = Thread.new do
          self.friend_ids.ids
        end
        user_ids = Thread.new do
          self.users(args).map(&:id)
        end
        follow!(user_ids.value - friend_ids.value, options)
      end
      alias friendship_create follow

      # Allows the authenticating user to follow the specified users
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/create
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The followed users.
      # @overload follow!(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Follow @sferik
      #     Twitter.follow!('sferik')
      # @overload follow!(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean] :follow (false) Enable notifications for the target user.
      def follow!(*args)
        options = args.extract_options!
        # Twitter always turns on notifications if the "follow" option is present, even if it's set to false
        # so only send follow if it's true
        options.merge!(:follow => true) if options.delete(:follow)
        args.flatten.threaded_map do |user|
          begin
            response = post("/1/friendships/create.json", options.merge_user(user))
            Twitter::User.from_response(response)
          rescue Twitter::Error::Forbidden
            # This error will be raised if the user doesn't have permission to
            # follow list_member, for whatever reason.
          end
        end.compact
      end
      alias friendship_create! follow!

      # Allows the authenticating user to unfollow the specified users
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/destroy
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The unfollowed users.
      # @overload unfollow(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Unfollow @sferik
      #     Twitter.unfollow('sferik')
      # @overload unfollow(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def unfollow(*args)
        users_from_response(:delete, "/1/friendships/destroy.json", args)
      end
      alias friendship_destroy unfollow

      # Returns the relationship of the authenticating user to the comma separated list of up to 100 screen_names or user_ids provided. Values for connections can be: following, following_requested, followed_by, none.
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/lookup
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The requested users.
      # @overload friendships(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Return extended information for @sferik and @pengwynn
      #     Twitter.friendships('sferik', 'pengwynn')
      #     Twitter.friendships('sferik', 14100886)   # Same as above
      #     Twitter.friendships(7505382, 14100886)    # Same as above
      # @overload friendships(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def friendships(*args)
        options = args.extract_options!
        options.merge_users!(Array(args))
        response = get("/1/friendships/lookup.json", options)
        collection_from_array(response[:body], Twitter::User)
      end

      # Allows one to enable or disable retweets and device notifications from the specified user.
      #
      # @see https://dev.twitter.com/docs/api/1/post/friendships/update
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Relationship]
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :device Enable/disable device notifications from the target user.
      # @option options [Boolean] :retweets Enable/disable retweets from the target user.
      # @example Enable rewteets and devise notifications for @sferik
      #   Twitter.friendship_update('sferik', :device => true, :retweets => true)
      def friendship_update(user, options={})
        options.merge_user!(user)
        response = post("/1/friendships/update.json", options)
        Twitter::Relationship.from_response(response)
      end

      # Returns an array of user_ids that the currently authenticated user does not want to see retweets from.
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/no_retweet_ids
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Integer>]
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :stringify_ids Many programming environments will not consume our ids due to their size. Provide this option to have ids returned as strings instead. Read more about Twitter IDs, JSON and Snowflake.
      # @example Enable rewteets and devise notifications for @sferik
      #   Twitter.no_retweet_ids
      def no_retweet_ids(options={})
        get("/1/friendships/no_retweet_ids.json", options)[:body]
      end

      # Allows the authenticating user to accept the specified users' follow requests
      #
      # @note Undocumented
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The accepted users.
      # @overload accept(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Accept @sferik's follow request
      #     Twitter.accept('sferik')
      # @overload accept(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def accept(*args)
        users_from_response(:post, "/1/friendships/accept.json", args)
      end

      # Allows the authenticating user to deny the specified users' follow requests
      #
      # @note Undocumented
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The denied users.
      # @overload deny(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Deny @sferik's follow request
      #     Twitter.deny('sferik')
      # @overload deny(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def deny(*args)
        users_from_response(:post, "/1/friendships/deny.json", args)
      end

    end
  end
end

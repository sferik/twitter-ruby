require 'twitter/api/utils'
require 'twitter/cursor'
require 'twitter/error/forbidden'
require 'twitter/relationship'
require 'twitter/user'

module Twitter
  module API
    module FriendsAndFollowers
      include Twitter::API::Utils

      # @see https://dev.twitter.com/docs/api/1.1/get/friends/ids
      # @rate_limited Yes
      # @authentication_required Requires user context
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
        ids_from_response(:get, "/1.1/friends/ids.json", args)
      end

      # @see https://dev.twitter.com/docs/api/1.1/get/followers/ids
      # @rate_limited Yes
      # @authentication_required Requires user context
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
        ids_from_response(:get, "/1.1/followers/ids.json", args)
      end

      # Returns the relationship of the authenticating user to the comma separated list of up to 100 screen_names or user_ids provided. Values for connections can be: following, following_requested, followed_by, none.
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/friendships/lookup
      # @rate_limited Yes
      # @authentication_required Requires user context
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
        collection_from_response(Twitter::User, :get, "/1.1/friendships/lookup.json", options)
      end

      # Returns an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/friendships/incoming
      # @rate_limited Yes
      # @authentication_required Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @example Return an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #   Twitter.friendships_incoming
      def friendships_incoming(options={})
        merge_default_cursor!(options)
        cursor_from_response(:ids, nil, :get, "/1.1/friendships/incoming.json", options)
      end

      # Returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/friendships/outgoing
      # @rate_limited Yes
      # @authentication_required Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @example Return an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #   Twitter.friendships_outgoing
      def friendships_outgoing(options={})
        merge_default_cursor!(options)
        cursor_from_response(:ids, nil, :get, "/1.1/friendships/outgoing.json", options)
      end

      # Allows the authenticating user to follow the specified users, unless they are already followed
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/friendships/create
      # @rate_limited No
      # @authentication_required Requires user context
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
        options[:follow] = true if !!options.delete(:follow)
        existing_friends = Thread.new do
          friend_ids.ids
        end
        new_friends = Thread.new do
          users(args).map(&:id)
        end
        follow!(new_friends.value - existing_friends.value, options)
      end
      alias friendship_create follow

      # Allows the authenticating user to follow the specified users
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/friendships/create
      # @rate_limited No
      # @authentication_required Requires user context
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
        options[:follow] = true if !!options.delete(:follow)
        args.flatten.threaded_map do |user|
          begin
            options.merge_user!(user)
            object_from_response(Twitter::User, :post, "/1.1/friendships/create.json", options)
          rescue Twitter::Error::Forbidden
            # This error will be raised if the user doesn't have permission to
            # follow list_member, for whatever reason.
          end
        end.compact
      end
      alias friendship_create! follow!

      # Allows the authenticating user to unfollow the specified users
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/friendships/destroy
      # @rate_limited No
      # @authentication_required Requires user context
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
        threaded_users_from_response(:post, "/1.1/friendships/destroy.json", args)
      end
      alias friendship_destroy unfollow

      # Allows one to enable or disable retweets and device notifications from the specified user.
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/friendships/update
      # @rate_limited No
      # @authentication_required Requires user context
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
        object_from_response(Twitter::Relationship, :post, "/1.1/friendships/update.json", options)
      end

      # Returns detailed information about the relationship between two users
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/friendships/show
      # @rate_limited Yes
      # @authentication_required Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
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
        object_from_response(Twitter::Relationship, :get, "/1.1/friendships/show.json", options)
      end
      alias friendship_show friendship
      alias relationship friendship

      # Test for the existence of friendship between two users
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/friendships/show
      # @rate_limited Yes
      # @authentication_required Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean] true if user_a follows user_b, otherwise false.
      # @param source [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the source user.
      # @param target [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the target user.
      # @param options [Hash] A customizable set of options.
      # @example Return true if @sferik follows @pengwynn
      #   Twitter.friendship?('sferik', 'pengwynn')
      #   Twitter.friendship?('sferik', 14100886)   # Same as above
      #   Twitter.friendship?(7505382, 14100886)    # Same as above
      def friendship?(source, target, options={})
        friendship(source, target, options).source.following?
      end

    end
  end
end

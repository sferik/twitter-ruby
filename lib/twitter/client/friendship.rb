require 'twitter/cursor'
require 'twitter/user'

module Twitter
  class Client
    # Defines methods related to friendship
    module Friendship
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
      # @example Follow @sferik
      #   Twitter.follow("sferik")
      def follow(user, options={})
        merge_user_into_options!(user, options)
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
      # @example Unfollow @sferik
      #   Twitter.unfollow("sferik")
      def unfollow(user, options={})
        merge_user_into_options!(user, options)
        user = delete("/1/friendships/destroy.json", options)
        Twitter::User.new(user)
      end
      alias :friendship_destroy :unfollow

      # Test for the existence of friendship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/exists
      # @note Consider using {Twitter::Client::Friendship#friendship} instead of this method.
      # @rate_limited Yes
      # @requires_authentication No unless user_a or user_b is protected
      # @param user_a [Integer, String] The ID or screen_name of the subject user.
      # @param user_b [Integer, String] The ID or screen_name of the user to test for following.
      # @param options [Hash] A customizable set of options.
      # @return [Boolean] true if user_a follows user_b, otherwise false.
      # @example Return true if @sferik follows @pengwynn
      #   Twitter.friendship?("sferik", "pengwynn")
      def friendship?(user_a, user_b, options={})
        get("/1/friendships/exists.json", options.merge(:user_a => user_a, :user_b => user_b))
      end

      # Returns detailed information about the relationship between two users
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/show
      # @rate_limited Yes
      # @requires_authentication No
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :source_id The ID of the subject user.
      # @option options [String] :source_screen_name The screen_name of the subject user.
      # @option options [Integer] :target_id The ID of the target user.
      # @option options [String] :target_screen_name The screen_name of the target user.
      # @return [Hash]
      # @example Return the relationship between @sferik and @pengwynn
      #   Twitter.friendship(:source_screen_name => "sferik", :target_screen_name => "pengwynn")
      #   Twitter.friendship(:source_id => 7505382, :target_id => 14100886)
      def friendship(user_a, user_b, options={})
        case user_a
        when Fixnum
          options[:source_id] = user_a
        when String
          options[:source_screen_name] = user_a
        end
        case user_b
        when Fixnum
          options[:target_id] = user_b
        when String
          options[:target_screen_name] = user_b
        end
        get("/1/friendships/show.json", options)['relationship']
      end
      alias :friendship_show :friendship
      alias :relationship :friendship

      # Returns an array of numeric IDs for every user who has a pending request to follow the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/friendships/incoming
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      # @return [Twitter::Cursor]
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
      # @example Return an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
      #   Twitter.friendships_outgoing
      def friendships_outgoing(options={})
        options = {:cursor => -1}.merge(options)
        cursor = get("/1/friendships/outgoing.json", options)
        Twitter::Cursor.new(cursor, 'ids')
      end
    end
  end
end

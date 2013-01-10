require 'twitter/action_factory'
require 'twitter/api/arguments'
require 'twitter/api/utils'
require 'twitter/cursor'
require 'twitter/tweet'
require 'twitter/user'

module Twitter
  module API
    module Undocumented
      include Twitter::API::Utils

      # Returns activity about me
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array] An array of actions
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @example Return activity about me
      #   Twitter.activity_about_me
      def activity_about_me(options={})
        objects_from_response(Twitter::ActionFactory, :get, "/i/activity/about_me.json", options)
      end

      # Returns activity by friends
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid./
      # @return [Array] An array of actions
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @example Return activity by friends
      #   Twitter.activity_by_friends
      def activity_by_friends(options={})
        objects_from_response(Twitter::ActionFactory, :get, "/i/activity/by_friends.json", options)
      end

      # @note Undocumented
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #
      # @overload following_followers_of(options={})
      #   Returns users following followers of the specified user
      #
      #   @param options [Hash] A customizable set of options.
      #     @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #     @return [Twitter::Cursor]
      #   @example Return users follow followers of @sferik
      #     Twitter.following_followers_of
      #
      # @overload following_followers_of(user, options={})
      #   Returns users following followers of the authenticated user
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #     @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
      #     @return [Twitter::Cursor]
      #   @example Return users follow followers of @sferik
      #     Twitter.following_followers_of('sferik')
      #     Twitter.following_followers_of(7505382)  # Same as above
      def following_followers_of(*args)
        cursor_from_response_with_user(:users, Twitter::User, :get, "/users/following_followers_of.json", args, :following_followers_of)
      end

      # Returns activity summary for a Tweet
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Tweet] The requested Tweet.
      # @param id [Integer] A Tweet ID.
      # @param options [Hash] A customizable set of options.
      # @example Return activity summary for the Tweet with the ID 25938088801
      #   Twitter.status_activity(25938088801)
      def status_activity(id, options={})
        response = get("/i/statuses/#{id}/activity/summary.json", options)
        response[:body].merge!(:id => id) if response[:body]
        Twitter::Tweet.from_response(response)
      end
      alias tweet_activity status_activity

      # Returns activity summary for Tweets
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>] The requested Tweets.
      # @overload statuses_activity(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Return activity summary for the Tweet with the ID 25938088801
      #     Twitter.statuses_activity(25938088801)
      # @overload statuses_activity(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @param options [Hash] A customizable set of options.
      def statuses_activity(*args)
        arguments = Twitter::API::Arguments.new(args)
        arguments.flatten.threaded_map do |id|
          status_activity(id, arguments.options)
        end
      end

    end
  end
end

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

      # Returns Tweets count for a URL
      #
      # @note Undocumented
      # @rate_limited No
      # @authentication Not required
      # @return [Integer]
      # @param url [Integer] A URL.
      # @param options [Hash] A customizable set of options.
      # @example Return Tweet count for http://twitter.com
      #   Twitter.tweet_count("http://twitter.com/")
      def tweet_count(url, options={})
        connection = Faraday.new("https://cdn.api.twitter.com", @connection_options.merge(:builder => @middleware))
        connection.get("/1/urls/count.json", options.merge(:url => url)).body[:count]
      end

    end
  end
end

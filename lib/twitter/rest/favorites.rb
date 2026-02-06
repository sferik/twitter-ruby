require "twitter/arguments"
require "twitter/error"
require "twitter/rest/utils"
require "twitter/tweet"
require "twitter/user"
require "twitter/utils"

module Twitter
  module REST
    # Methods for working with favorite tweets
    module Favorites
      include Twitter::REST::Utils
      include Twitter::Utils

      # Returns favorite Tweets for the user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/favorites/list
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.favorites
      # @return [Array<Twitter::Tweet>] favorite Tweets.
      # @overload favorites(options = {})
      #   Returns the 20 most recent favorite Tweets for the authenticating user
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @overload favorites(user, options = {})
      #   Returns the 20 most recent favorite Tweets for the specified user
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      def favorites(*args)
        arguments = Arguments.new(args)
        merge_user!(arguments.options, arguments.pop) if arguments.last
        perform_get_with_objects("/1.1/favorites/list.json", arguments.options, Tweet)
      end

      # Un-favorites the specified Tweets as the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/favorites/destroy
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.unfavorite(25938088801)
      # @return [Array<Twitter::Tweet>] The un-favorited Tweets.
      # @overload unfavorite(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload unfavorite(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      def unfavorite(*args)
        arguments = Arguments.new(args)
        pmap(arguments) do |tweet|
          perform_post_with_object("/1.1/favorites/destroy.json", arguments.options.merge(id: extract_id(tweet)), Tweet)
        rescue Error::NotFound
          nil
        end.compact
      end
      # @!method destroy_favorite
      #   @api public
      #   @see #unfavorite
      alias destroy_favorite unfavorite

      # Un-favorites the specified Tweets and raises an error if not found
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/favorites/destroy
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::NotFound] Error raised when tweet does not exist or has been deleted.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.unfavorite!(25938088801)
      # @return [Array<Twitter::Tweet>] The un-favorited Tweets.
      # @overload unfavorite!(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload unfavorite!(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      def unfavorite!(*args)
        parallel_objects_from_response(Tweet, :post, "/1.1/favorites/destroy.json", args)
      end

      # Favorites the specified Tweets as the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/favorites/create
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.favorite(25938088801)
      # @return [Array<Twitter::Tweet>] The favorited Tweets.
      # @overload favorite(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload favorite(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      def favorite(*args)
        arguments = Arguments.new(args)
        pmap(arguments) do |tweet|
          perform_post_with_object("/1.1/favorites/create.json", arguments.options.merge(id: extract_id(tweet)), Tweet)
        rescue Error::AlreadyFavorited, Error::NotFound
          nil
        end.compact
      end
      # @!method fav
      #   @api public
      #   @see #favorite
      alias fav favorite
      # @!method fave
      #   @api public
      #   @see #favorite
      alias fave favorite

      # Favorites the specified Tweets and raises an error if already favorited
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/favorites/create
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::AlreadyFavorited] Error raised when tweet has already been favorited.
      # @raise [Twitter::Error::NotFound] Error raised when tweet does not exist or has been deleted.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.favorite!(25938088801)
      # @return [Array<Twitter::Tweet>] The favorited Tweets.
      # @overload favorite!(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload favorite!(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      def favorite!(*args)
        arguments = Arguments.new(args)
        pmap(arguments) do |tweet|
          perform_post_with_object("/1.1/favorites/create.json", arguments.options.merge(id: extract_id(tweet)), Tweet)
        end
      end
      # @!method create_favorite!
      #   @api public
      #   @see #favorite!
      alias create_favorite! favorite!
      # @!method fav!
      #   @api public
      #   @see #favorite!
      alias fav! favorite!
      # @!method fave!
      #   @api public
      #   @see #favorite!
      alias fave! favorite!
    end
  end
end

require 'twitter/arguments'
require 'twitter/error/already_favorited'
require 'twitter/error/forbidden'
require 'twitter/rest/api/utils'
require 'twitter/tweet'
require 'twitter/user'

module Twitter
  module REST
    module API
      module Favorites
        include Twitter::REST::API::Utils

        # @see https://dev.twitter.com/docs/api/1.1/get/favorites/list
        # @rate_limited Yes
        # @authentication Requires user context
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @return [Array<Twitter::Tweet>] favorite Tweets.
        # @overload favorites(options={})
        #   Returns the 20 most recent favorite Tweets for the authenticating user
        #
        #   @param options [Hash] A customizable set of options.
        #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
        #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
        # @overload favorites(user, options={})
        #   Returns the 20 most recent favorite Tweets for the specified user
        #
        #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
        #   @param options [Hash] A customizable set of options.
        #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
        #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
        def favorites(*args)
          arguments = Twitter::Arguments.new(args)
          if user = arguments.pop
            merge_user!(arguments.options, user)
          end
          objects_from_response(Twitter::Tweet, :get, "/1.1/favorites/list.json", arguments.options)
        end
        alias favourites favorites

        # Un-favorites the specified Tweets as the authenticating user
        #
        # @see https://dev.twitter.com/docs/api/1.1/post/favorites/destroy
        # @rate_limited No
        # @authentication Requires user context
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @return [Array<Twitter::Tweet>] The un-favorited Tweets.
        # @overload unfavorite(*tweets)
        #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
        # @overload unfavorite(*tweets, options)
        #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
        #   @param options [Hash] A customizable set of options.
        def unfavorite(*args)
          threaded_objects_from_response(Twitter::Tweet, :post, "/1.1/favorites/destroy.json", args)
        end
        alias favorite_destroy unfavorite
        alias favourite_destroy unfavorite
        alias unfavourite unfavorite

        # Favorites the specified Tweets as the authenticating user
        #
        # @see https://dev.twitter.com/docs/api/1.1/post/favorites/create
        # @rate_limited No
        # @authentication Requires user context
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @return [Array<Twitter::Tweet>] The favorited Tweets.
        # @overload favorite(*tweets)
        #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
        # @overload favorite(*tweets, options)
        #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
        #   @param options [Hash] A customizable set of options.
        def favorite(*args)
          arguments = Twitter::Arguments.new(args)
          arguments.flatten.threaded_map do |tweet|
            id = extract_id(tweet)
            begin
              object_from_response(Twitter::Tweet, :post, "/1.1/favorites/create.json", arguments.options.merge(:id => id))
            rescue Twitter::Error::Forbidden => error
              raise unless error.message == Twitter::Error::AlreadyFavorited::MESSAGE
            end
          end.compact
        end
        alias fav favorite
        alias fave favorite
        alias favorite_create favorite
        alias favourite_create favorite

        # Favorites the specified Tweets as the authenticating user and raises an error if one has already been favorited
        #
        # @see https://dev.twitter.com/docs/api/1.1/post/favorites/create
        # @rate_limited No
        # @authentication Requires user context
        # @raise [Twitter::Error::AlreadyFavorited] Error raised when tweet has already been favorited.
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @return [Array<Twitter::Tweet>] The favorited Tweets.
        # @overload favorite(*tweets)
        #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
        # @overload favorite(*tweets, options)
        #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
        #   @param options [Hash] A customizable set of options.
        def favorite!(*args)
          arguments = Twitter::Arguments.new(args)
          arguments.flatten.threaded_map do |tweet|
            id = extract_id(tweet)
            begin
              object_from_response(Twitter::Tweet, :post, "/1.1/favorites/create.json", arguments.options.merge(:id => id))
            rescue Twitter::Error::Forbidden => error
              handle_forbidden_error(Twitter::Error::AlreadyFavorited, error)
            end
          end
        end
        alias fav! favorite!
        alias fave! favorite!
        alias favorite_create! favorite!
        alias favourite_create! favorite!

      end
    end
  end
end

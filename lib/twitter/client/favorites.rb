module Twitter
  class Client
    # Defines methods related to favorites (or favourites)
    module Favorites
      # @see https://dev.twitter.com/docs/api/1/get/favorites
      # @rate_limited Yes
      # @requires_authentication No
      # @overload favorites(options={})
      #   Returns the 20 most recent favorite statuses for the authenticating user
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array] 20 favorite statuses.
      #   @example Return the 20 most recent favorite statuses for the authenticating user
      #     Twitter.favorites
      # @overload favorites(user, options={})
      #   Returns the 20 most recent favorite statuses for the specified user
      #
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @return [Array] 20 favorite statuses.
      #   @example Return the 20 most recent favorite statuses for @sferik
      #     Twitter.favorites("sferik")
      def favorites(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if user = args.first
          get("/1/favorites/#{user}.json", options)
        else
          get("/1/favorites.json", options)
        end
      end

      # Favorites the specified status as the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/favorites/create/:id
      # @rate_limited No
      # @requires_authentication Yes
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The favorited status.
      # @example Favorite the status with the ID 25938088801
      #   Twitter.favorite_create(25938088801)
      def favorite_create(id, options={})
        post("/1/favorites/create/#{id}.json", options)
      end

      # Un-favorites the specified status as the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/favorites/destroy/:id
      # @rate_limited No
      # @requires_authentication Yes
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The un-favorited status.
      # @example Un-favorite the status with the ID 25938088801
      #   Twitter.favorite_destroy(25938088801)
      def favorite_destroy(id, options={})
        delete("/1/favorites/destroy/#{id}.json", options)
      end
    end
  end
end

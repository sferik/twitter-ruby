require 'twitter/saved_search'

module Twitter
  class Client
    # Defines methods related to saved searches
    module SavedSearches

      # Returns the authenticated user's saved search queries
      #
      # @see https://dev.twitter.com/docs/api/1/get/saved_searches
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @return [Array<Twitter::SavedSearch>] Saved search queries.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the authenticated user's saved search queries
      #   Twitter.saved_searches
      def saved_searches(options={})
        get("/1/saved_searches.json", options).map do |saved_search|
          Twitter::SavedSearch.new(saved_search)
        end
      end

      # Retrieve the data for a saved search owned by the authenticating user specified by the given ID
      #
      # @see https://dev.twitter.com/docs/api/1/get/saved_searches/show/:id
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param id [Integer] The ID of the saved search.
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::SavedSearch] The saved search.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
      #   Twitter.saved_search(16129012)
      def saved_search(id, options={})
        saved_search = get("/1/saved_searches/show/#{id}.json", options)
        Twitter::SavedSearch.new(saved_search)
      end

      # Creates a saved search for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1/post/saved_searches/create
      # @rate_limited No
      # @requires_authentication Yes
      # @param query [String] The query of the search the user would like to save.
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::SavedSearch] The created saved search.
      # @example Create a saved search for the authenticated user with the query "twitter"
      #   Twitter.saved_search_create("twitter")
      def saved_search_create(query, options={})
        saved_search = post("/1/saved_searches/create.json", options.merge(:query => query))
        Twitter::SavedSearch.new(saved_search)
      end

      # Destroys a saved search for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1/post/saved_searches/destroy/:id
      # @note The search specified by ID must be owned by the authenticating user.
      # @rate_limited No
      # @requires_authentication Yes
      # @param id [Integer] The ID of the saved search.
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::SavedSearch] The deleted saved search.
      # @example Destroys a saved search for the authenticated user with the ID 16129012
      #   Twitter.saved_search_destroy(16129012)
      def saved_search_destroy(id, options={})
        saved_search = delete("/1/saved_searches/destroy/#{id}.json", options)
        Twitter::SavedSearch.new(saved_search)
      end

    end
  end
end

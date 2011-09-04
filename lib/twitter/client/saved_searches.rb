module Twitter
  class Client
    # Defines methods related to saved searches
    module SavedSearches
      # Returns the authenticated user's saved search queries
      #
      # @see https://dev.twitter.com/docs/api/1/get/saved_searches
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @return [Array] Saved search queries.
      # @example Return the authenticated user's saved search queries
      #   Twitter.saved_searches
      def saved_searches(options={})
        response = get('1/saved_searches', options)
        format.to_s.downcase == 'xml' ? response['saved_searches'] : response
      end

      # Retrieve the data for a saved search owned by the authenticating user specified by the given ID
      #
      # @see https://dev.twitter.com/docs/api/1/get/saved_searches/show/:id
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param id [Integer] The ID of the saved search.
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash] The saved search.
      # @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
      #   Twitter.saved_search(16129012)
      def saved_search(id, options={})
        response = get("1/saved_searches/show/#{id}", options)
        format.to_s.downcase == 'xml' ? response['saved_search'] : response
      end

      # Creates a saved search for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1/post/saved_searches/create
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param query [String] The query of the search the user would like to save.
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash] The created saved search.
      # @example Create a saved search for the authenticated user with the query "twitter"
      #   Twitter.saved_search_create("twitter")
      def saved_search_create(query, options={})
        response = post('1/saved_searches/create', options.merge(:query => query))
        format.to_s.downcase == 'xml' ? response['saved_search'] : response
      end

      # Destroys a saved search for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1/post/saved_searches/destroy/:id
      # @note The search specified by ID must be owned by the authenticating user.
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param id [Integer] The ID of the saved search.
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash] The deleted saved search.
      # @example Destroys a saved search for the authenticated user with the ID 16129012
      #   Twitter.saved_search_destroy(16129012)
      def saved_search_destroy(id, options={})
        response = delete("1/saved_searches/destroy/#{id}", options)
        format.to_s.downcase == 'xml' ? response['saved_search'] : response
      end
    end
  end
end

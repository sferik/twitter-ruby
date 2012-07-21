require 'twitter/api/utils'
require 'twitter/core_ext/array'
require 'twitter/core_ext/enumerable'
require 'twitter/saved_search'

module Twitter
  module API
    module SavedSearches
      include Twitter::API::Utils

      def self.included(klass)
        klass.class_variable_get(:@@rate_limited).merge!(
          :saved_searches => true,
          :saved_search => true,
          :saved_search_create => false,
          :saved_search_destroy => false,
        )
      end

      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::SavedSearch>] The saved searches.
      # @overload saved_search(options={})
      #   Returns the authenticated user's saved search queries
      #
      #   @see https://dev.twitter.com/docs/api/1/get/saved_searches
      #   @param options [Hash] A customizable set of options.
      #   @example Return the authenticated user's saved search queries
      #     Twitter.saved_searches
      # @overload saved_search(*ids)
      #   Retrieve the data for saved searches owned by the authenticating user
      #
      #   @see https://dev.twitter.com/docs/api/1/get/saved_searches/show/:id
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
      #     Twitter.saved_search(16129012)
      # @overload saved_search(*ids, options)
      #   Retrieve the data for saved searches owned by the authenticating user
      #
      #   @see https://dev.twitter.com/docs/api/1/get/saved_searches/show/:id
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @param options [Hash] A customizable set of options.
      def saved_searches(*args)
        options = args.extract_options!
        if args.empty?
          response = get("/1/saved_searches.json", options)
          collection_from_array(response[:body], Twitter::SavedSearch)
        else
          args.flatten.threaded_map do |id|
            response = get("/1/saved_searches/show/#{id}.json", options)
            Twitter::SavedSearch.from_response(response)
          end
        end
      end

      # Retrieve the data for saved searches owned by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/saved_searches/show/:id
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::SavedSearch] The saved searches.
      # @param id [Integer] A Twitter status IDs.
      # @param options [Hash] A customizable set of options.
      # @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
      #   Twitter.saved_search(16129012)
      def saved_search(id, options={})
        response = get("/1/saved_searches/show/#{id}.json", options)
        Twitter::SavedSearch.from_response(response)
      end

      # Creates a saved search for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1/post/saved_searches/create
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::SavedSearch] The created saved search.
      # @param query [String] The query of the search the user would like to save.
      # @param options [Hash] A customizable set of options.
      # @example Create a saved search for the authenticated user with the query "twitter"
      #   Twitter.saved_search_create("twitter")
      def saved_search_create(query, options={})
        response = post("/1/saved_searches/create.json", options.merge(:query => query))
        Twitter::SavedSearch.from_response(response)
      end

      # Destroys saved searches for the authenticated user
      #
      # @see https://dev.twitter.com/docs/api/1/post/saved_searches/destroy/:id
      # @note The search specified by ID must be owned by the authenticating user.
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::SavedSearch>] The deleted saved searches.
      # @overload saved_search_destroy(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @example Destroys a saved search for the authenticated user with the ID 16129012
      #     Twitter.saved_search_destroy(16129012)
      # @overload saved_search_destroy(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @param options [Hash] A customizable set of options.
      def saved_search_destroy(*args)
        options = args.extract_options!
        args.flatten.threaded_map do |id|
          response = delete("/1/saved_searches/destroy/#{id}.json", options)
          Twitter::SavedSearch.from_response(response)
        end
      end

    end
  end
end

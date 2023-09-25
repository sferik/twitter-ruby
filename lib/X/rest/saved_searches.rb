require "X/arguments"
require "X/rest/utils"
require "X/saved_search"
require "X/utils"

module X
  module REST
    module SavedSearches
      include X::REST::Utils
      include X::Utils

      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<X::SavedSearch>] The saved searches.
      # @overload saved_search(options = {})
      #   Returns the authenticated user's saved search queries
      #
      #   @see https://dev.X.com/rest/reference/get/saved_searches/list
      #   @param options [Hash] A customizable set of options.
      # @overload saved_search(*ids)
      #   Retrieve the data for saved searches owned by the authenticating user
      #
      #   @see https://dev.X.com/rest/reference/get/saved_searches/show/:id
      #   @param ids [Enumerable<Integer>] A collection of saved search IDs.
      # @overload saved_search(*ids, options)
      #   Retrieve the data for saved searches owned by the authenticating user
      #
      #   @see https://dev.X.com/rest/reference/get/saved_searches/show/:id
      #   @param ids [Enumerable<Integer>] A collection of saved search IDs.
      #   @param options [Hash] A customizable set of options.
      def saved_searches(*args)
        arguments = X::Arguments.new(args)
        if arguments.empty?
          perform_get_with_objects("/1.1/saved_searches/list.json", arguments.options, X::SavedSearch)
        else
          pmap(arguments) do |id|
            saved_search(id, arguments.options)
          end
        end
      end

      # Retrieve the data for saved searches owned by the authenticating user
      #
      # @see https://dev.X.com/rest/reference/get/saved_searches/show/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [X::SavedSearch] The saved searches.
      # @param id [Integer] The ID of the saved search.
      # @param options [Hash] A customizable set of options.
      def saved_search(id, options = {})
        perform_get_with_object("/1.1/saved_searches/show/#{id}.json", options, X::SavedSearch)
      end

      # Creates a saved search for the authenticated user
      #
      # @see https://dev.X.com/rest/reference/post/saved_searches/create
      # @rate_limited No
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [X::SavedSearch] The created saved search.
      # @param query [String] The query of the search the user would like to save.
      # @param options [Hash] A customizable set of options.
      def create_saved_search(query, options = {})
        perform_post_with_object("/1.1/saved_searches/create.json", options.merge(query: query), X::SavedSearch)
      end

      # Destroys saved searches for the authenticated user
      #
      # @see https://dev.X.com/rest/reference/post/saved_searches/destroy/:id
      # @note The search specified by ID must be owned by the authenticating user.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<X::SavedSearch>] The deleted saved searches.
      # @overload destroy_saved_search(*ids)
      #   @param ids [Enumerable<Integer>] A collection of saved search IDs.
      # @overload destroy_saved_search(*ids, options)
      #   @param ids [Enumerable<Integer>] A collection of saved search IDs.
      #   @param options [Hash] A customizable set of options.
      def destroy_saved_search(*args)
        arguments = X::Arguments.new(args)
        pmap(arguments) do |id|
          perform_post_with_object("/1.1/saved_searches/destroy/#{id}.json", arguments.options, X::SavedSearch)
        end
      end
    end
  end
end

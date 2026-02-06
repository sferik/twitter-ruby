require "twitter/arguments"
require "twitter/rest/utils"
require "twitter/saved_search"
require "twitter/utils"

module Twitter
  module REST
    # Methods for working with saved searches
    module SavedSearches
      include Twitter::REST::Utils
      include Twitter::Utils

      # Returns the authenticated user's saved search queries
      #
      # @api public
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.saved_searches
      # @return [Array<Twitter::SavedSearch>] The saved searches.
      # @overload saved_search(options = {})
      #   Returns the authenticated user's saved search queries
      #
      #   @see https://dev.twitter.com/rest/reference/get/saved_searches/list
      #   @param options [Hash] A customizable set of options.
      # @overload saved_search(*ids)
      #   Retrieve the data for saved searches owned by the authenticating user
      #
      #   @see https://dev.twitter.com/rest/reference/get/saved_searches/show/:id
      #   @param ids [Enumerable<Integer>] A collection of saved search IDs.
      # @overload saved_search(*ids, options)
      #   Retrieve the data for saved searches owned by the authenticating user
      #
      #   @see https://dev.twitter.com/rest/reference/get/saved_searches/show/:id
      #   @param ids [Enumerable<Integer>] A collection of saved search IDs.
      #   @param options [Hash] A customizable set of options.
      def saved_searches(*args)
        arguments = Arguments.new(args)
        if arguments.empty?
          perform_get_with_objects("/1.1/saved_searches/list.json", arguments.options, SavedSearch)
        else
          pmap(arguments) do |id|
            saved_search(id, arguments.options)
          end
        end
      end

      # Retrieves a saved search by ID
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/saved_searches/show/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.saved_search(16129012)
      # @return [Twitter::SavedSearch] The saved searches.
      # @param id [Integer] The ID of the saved search.
      # @param options [Hash] A customizable set of options.
      def saved_search(id, options = {})
        perform_get_with_object("/1.1/saved_searches/show/#{id}.json", options, SavedSearch)
      end

      # Creates a saved search for the authenticated user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/saved_searches/create
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.create_saved_search('twitter')
      # @return [Twitter::SavedSearch] The created saved search.
      # @param query [String] The query of the search the user would like to save.
      # @param options [Hash] A customizable set of options.
      def create_saved_search(query, options = {})
        perform_post_with_object("/1.1/saved_searches/create.json", options.merge(query:), SavedSearch)
      end

      # Destroys saved searches for the authenticated user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/saved_searches/destroy/:id
      # @note The search specified by ID must be owned by the authenticating user.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.destroy_saved_search(16129012)
      # @return [Array<Twitter::SavedSearch>] The deleted saved searches.
      # @overload destroy_saved_search(*ids)
      #   @param ids [Enumerable<Integer>] A collection of saved search IDs.
      # @overload destroy_saved_search(*ids, options)
      #   @param ids [Enumerable<Integer>] A collection of saved search IDs.
      #   @param options [Hash] A customizable set of options.
      def destroy_saved_search(*args)
        arguments = Arguments.new(args)
        pmap(arguments) do |id|
          perform_post_with_object("/1.1/saved_searches/destroy/#{id}.json", arguments.options, SavedSearch)
        end
      end
    end
  end
end

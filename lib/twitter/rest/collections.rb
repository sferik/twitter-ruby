require 'twitter/rest/utils'
require 'twitter/tweet'

module Twitter
  module REST
    module Collections
      include Twitter::REST::Utils
      DEFAULT_TWEETS_PER_REQUEST = 20
      MAX_TWEETS_PER_REQUEST = 200

      # Returns the 20 most recent tweets in the given collection
      #
      # @see https://dev.twitter.com/rest/reference/get/collections/list
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied use credentials are not valid.
      # @return [Array<Twitter::Tweet>]
      # @overload user_timeline(collection_id, options = {})
      #   @param collection_id [String] A twitter collection id
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :count Specifies the maximum number of results to include in the response.  Between 1 and 200.
      #   @option options [Integer] :max_position Returns results with a position value less than or equal to the specified position.
      #   @option options [Integer] :min_position Returns results with a position greater than the specified position.
      def collection_entries(*args)
        objects_from_response_with_collection(Twitter::Tweet, :get, '/1.1/collections/entries.json', args)
      end
    end
  end
end
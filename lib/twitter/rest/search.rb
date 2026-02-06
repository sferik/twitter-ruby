require "twitter/rest/request"
require "twitter/search_results"

module Twitter
  module REST
    # Methods for searching tweets
    module Search
      # Maximum tweets per request
      MAX_TWEETS_PER_REQUEST = 100

      # Returns tweets that match a specified query
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/search/tweets
      # @note Not all Tweets will be indexed or made available via the search interface.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.search('twitter')
      # @param query [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :geocode Returns tweets by users located within a given radius.
      # @option options [String] :lang Restricts tweets to the given language.
      # @option options [String] :locale Specify the language of the query you are sending.
      # @option options [String] :result_type Specifies result type: mixed, recent, or popular.
      # @option options [Integer] :count The number of tweets to return per page.
      # @option options [String] :until Returns tweets generated before the given date.
      # @option options [Integer] :since_id Returns results with an ID greater than the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than the specified ID.
      # @option options [Boolean] :include_entities Include entities node.
      # @option options [String] :tweet_mode Tweet text mode: compat or extended.
      # @return [Twitter::SearchResults] Tweets matching the query with search metadata.
      def search(query, options = {})
        options = options.dup
        options[:count] ||= MAX_TWEETS_PER_REQUEST
        request = Twitter::REST::Request.new(self, :get, "/1.1/search/tweets.json", options.merge(q: query))
        Twitter::SearchResults.new(request)
      end
    end
  end
end

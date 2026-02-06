require "twitter/rest/request"
require "twitter/premium_search_results"

module Twitter
  module REST
    # Methods for Premium Search API
    module PremiumSearch
      # Maximum tweets per request
      MAX_TWEETS_PER_REQUEST = 100

      # Returns tweets from the Premium API that match a specified query
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/tweets/search/overview/premium
      # @rate_limited Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.premium_search('twitter')
      # @param query [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :tag Tags for segregating rules into logical groups.
      # @option options [Integer] :maxResults The maximum number of search results.
      # @option options [String] :fromDate The oldest UTC timestamp.
      # @option options [String] :toDate The latest UTC timestamp.
      # @param request_config [Hash] Request configuration options.
      # @option request_config [String] :product The search endpoint (30day or fullarchive).
      # @return [Twitter::PremiumSearchResults] Tweets matching the query.
      def premium_search(query, options = {}, request_config = {})
        options = options.clone
        options[:maxResults] ||= MAX_TWEETS_PER_REQUEST # steep:ignore UnresolvedOverloading
        request_config[:request_method] = :json_post if request_config[:request_method].nil? || request_config[:request_method] == :post
        request_config[:product] ||= "30day"
        path = "/1.1/tweets/search/#{request_config[:product]}/#{dev_environment}.json" # steep:ignore NoMethod
        request = Twitter::REST::Request.new(self, request_config[:request_method], path, options.merge(query:)) # steep:ignore NoMethod
        Twitter::PremiumSearchResults.new(request, request_config)
      end
    end
  end
end

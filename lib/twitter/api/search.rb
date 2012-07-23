require 'twitter/api/utils'
require 'twitter/search_results'

module Twitter
  module API
    module Search
      include Twitter::API::Utils

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :search => true,
            :phoenix_search => true,
          }
        )
      end

      # Returns tweets that match a specified query.
      #
      # @see https://dev.twitter.com/docs/api/1/get/search
      # @see https://dev.twitter.com/docs/using-search
      # @see https://dev.twitter.com/docs/history-rest-search-api
      # @note As of April 1st 2010, the Search API provides an option to retrieve "popular tweets" in addition to real-time search results. In an upcoming release, this will become the default and clients that don't want to receive popular tweets in their search results will have to explicitly opt-out. See the result_type parameter below for more information.
      # @rate_limited Yes
      # @authentication_required No
      # @param q [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :geocode Returns tweets by users located within a given radius of the given latitude/longitude. The location is preferentially taking from the Geotagging API, but will fall back to their Twitter profile. The parameter value is specified by "latitude,longitude,radius", where radius units must be specified as either "mi" (miles) or "km" (kilometers). Note that you cannot use the near operator via the API to geocode arbitrary locations; however you can use this geocode parameter to search near geocodes directly.
      # @option options [String] :lang Restricts tweets to the given language, given by an ISO 639-1 code.
      # @option options [String] :locale Specify the language of the query you are sending (only ja is currently effective). This is intended for language-specific clients and the default should work in the majority of cases.
      # @option options [Integer] :page The page number (starting at 1) to return, up to a max of roughly 1500 results (based on rpp * page).
      # @option options [String] :result_type Specifies what type of search results you would prefer to receive. Options are "mixed", "recent", and "popular". The current default is "mixed."
      # @option options [Integer] :rpp The number of tweets to return per page, up to a max of 100.
      # @option options [String] :until Optional. Returns tweets generated before the given date. Date should be formatted as YYYY-MM-DD.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID. There are limits to the number of Tweets which can be accessed through the API. If the limit of Tweets has occured since the since_id, the since_id will be forced to the oldest ID available.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Boolean, String, Integer] :with_twitter_user_id When set to either true, t or 1, the from_user_id and to_user_id values in the response will map to "official" user IDs which will match those returned by the REST API.
      # @return [Twitter::SearchResults] Return tweets that match a specified query with search metadata
      # @example Returns tweets related to twitter
      #   Twitter.search('twitter')
      def search(q, options={})
        response = get("/search.json", options.merge(:q => q), :endpoint => @search_endpoint)
        Twitter::SearchResults.from_response(response)
      end

      # Returns recent statuses related to a query with images and videos embedded
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication_required No
      # @param q [String] A search term.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @return [Array<Twitter::Status>] An array of statuses that contain videos
      # @example Return recent statuses related to twitter with images and videos embedded
      #   Twitter.phoenix_search('twitter')
      def phoenix_search(q, options={})
        search_collection_from_response(:get, "/phoenix_search.phoenix", options.merge(:q => q))
      end

    private

      # @param method [Symbol]
      # @param url [String]
      # @param options [Hash]
      # @param klass [Class]
      # @return [Array]
      def search_collection_from_response(method, url, options, klass=Twitter::Status)
        collection_from_array(self.send(method.to_sym, url, options)[:body][:statuses], klass)
      end

    end
  end
end

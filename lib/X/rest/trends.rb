require "X/place"
require "X/rest/request"
require "X/rest/utils"
require "X/trend_results"

module X
  module REST
    module Trends
      include X::REST::Utils

      # Returns the top 50 trending topics for a specific WOEID
      #
      # @see https://dev.X.com/rest/reference/get/trends/place
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param id [Integer] The {https://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. WOEIDs can be retrieved by calling {X::REST::Trends#trends_available}. Global information is available by using 1 as the WOEID.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Array<X::Trend>]
      def trends(id = 1, options = {})
        options = options.dup
        options[:id] = id
        response = perform_get("/1.1/trends/place.json", options).first
        X::TrendResults.new(response)
      end
      alias local_trends trends
      alias trends_place trends

      # Returns the locations that X has trending topic information for
      #
      # @see https://dev.X.com/rest/reference/get/trends/available
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param options [Hash] A customizable set of options.
      # @return [Array<X::Place>]
      def trends_available(options = {})
        perform_get_with_objects("/1.1/trends/available.json", options, X::Place)
      end
      alias trend_locations trends_available

      # Returns the locations that X has trending topic information for, closest to a specified location.
      #
      # @see https://dev.X.com/rest/reference/get/trends/closest
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat If provided with a :long option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for latitude are -90.0 to +90.0 (North is positive) inclusive.
      # @option options [Float] :long If provided with a :lat option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for longitude are -180.0 to +180.0 (East is positive) inclusive.
      # @return [Array<X::Place>]
      def trends_closest(options = {})
        perform_get_with_objects("/1.1/trends/closest.json", options, X::Place)
      end
    end
  end
end

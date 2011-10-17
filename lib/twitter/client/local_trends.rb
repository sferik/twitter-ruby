require 'twitter/place'
require 'twitter/trend'

module Twitter
  class Client
    # Defines methods related to local trends
    # @see Twitter::Client::Trends
    module LocalTrends

      # Returns the top 10 trending topics for a specific WOEID
      #
      # @see https://dev.twitter.com/docs/api/1/get/trends/:woeid
      # @rate_limited Yes
      # @requires_authentication No
      # @param woeid [Integer] The {https://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. WOEIDs can be retrieved by calling {Twitter::Client::LocalTrends#trend_locations}. Global information is available by using 1 as the WOEID.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Array<Twitter::Trend>]
      # @example Return the top 10 trending topics for San Francisco
      #   Twitter.local_trends(2487956)
      def local_trends(woeid=1, options={})
        get("/1/trends/#{woeid}.json", options).first['trends'].map do |trend|
          Twitter::Trend.new(trend)
        end
      end

      # Returns the locations that Twitter has trending topic information for
      #
      # @see https://dev.twitter.com/docs/api/1/get/trends/available
      # @rate_limited Yes
      # @requires_authentication No
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat If provided with a :long option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for latitude are -90.0 to +90.0 (North is positive) inclusive.
      # @option options [Float] :long If provided with a :lat option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for longitude are -180.0 to +180.0 (East is positive) inclusive.
      # @return [Array<Twitter::Place>]
      # @example Return the locations that Twitter has trending topic information for
      #   Twitter.trend_locations
      def trend_locations(options={})
        get("/1/trends/available.json", options).map do |place|
          Twitter::Place.new(place)
        end
      end

    end
  end
end

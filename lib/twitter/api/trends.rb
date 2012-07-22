require 'twitter/api/utils'
require 'twitter/place'
require 'twitter/trend'

module Twitter
  module API
    module Trends
      include Twitter::API::Utils

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :local_trends => true,
            :trends => true,
            :trend_locations => true,
            :trends_daily => true,
            :trends_weekly => true,
          }
        )
      end

      # Returns the top 10 trending topics for a specific WOEID
      #
      # @see https://dev.twitter.com/docs/api/1/get/trends/:woeid
      # @rate_limited Yes
      # @authentication_required No
      # @param woeid [Integer] The {https://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. WOEIDs can be retrieved by calling {Twitter::API::Trends#trend_locations}. Global information is available by using 1 as the WOEID.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Array<Twitter::Trend>]
      # @example Return the top 10 trending topics for San Francisco
      #   Twitter.local_trends(2487956)
      def local_trends(woeid=1, options={})
        response = get("/1/trends/#{woeid}.json", options)
        collection_from_array(response[:body].first[:trends], Twitter::Trend)
      end
      alias trends local_trends

      # Returns the locations that Twitter has trending topic information for
      #
      # @see https://dev.twitter.com/docs/api/1/get/trends/available
      # @rate_limited Yes
      # @authentication_required No
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat If provided with a :long option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for latitude are -90.0 to +90.0 (North is positive) inclusive.
      # @option options [Float] :long If provided with a :lat option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for longitude are -180.0 to +180.0 (East is positive) inclusive.
      # @return [Array<Twitter::Place>]
      # @example Return the locations that Twitter has trending topic information for
      #   Twitter.trend_locations
      def trend_locations(options={})
        collection_from_response(:get, "/1/trends/available.json", options, Twitter::Place)
      end

      # Returns the top 20 trending topics for each hour in a given day
      #
      # @see https://dev.twitter.com/docs/api/1/get/trends/daily
      # @rate_limited Yes
      # @authentication_required No
      # @param date [Date] The start date for the report. A 404 error will be thrown if the date is older than the available search index (7-10 days). Dates in the future will be forced to the current date.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Hash]
      # @example Return the top 20 trending topics for each hour of October 24, 2010
      #   Twitter.trends_daily(Date.parse("2010-10-24"))
      def trends_daily(date=Date.today, options={})
        trends_periodically("/1/trends/daily.json", date, options)
      end

      # Returns the top 30 trending topics for each day in a given week
      #
      # @see https://dev.twitter.com/docs/api/1/get/trends/weekly
      # @rate_limited Yes
      # @authentication_required No
      # @param date [Date] The start date for the report. A 404 error will be thrown if the date is older than the available search index (7-10 days). Dates in the future will be forced to the current date.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Hash]
      # @example Return the top ten topics that are currently trending on Twitter
      #   Twitter.trends_weekly(Date.parse("2010-10-24"))
      def trends_weekly(date=Date.today, options={})
        trends_periodically("/1/trends/weekly.json", date, options)
      end

    private

      def trends_periodically(url, date, options)
        response = get(url, options.merge(:date => date.strftime('%Y-%m-%d')))
        trends = {}
        response[:body][:trends].each do |key, value|
          trends[key] = []
          value.each do |trend|
            trends[key] << Twitter::Trend.fetch_or_new(trend)
          end
        end
        trends
      end

    end
  end
end

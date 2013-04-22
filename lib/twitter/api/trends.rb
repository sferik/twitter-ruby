require 'twitter/api/utils'
require 'twitter/place'
require 'twitter/trend'

module Twitter
  module API
    module Trends
      include Twitter::API::Utils

      # Returns the top 10 trending topics for a specific WOEID
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/trends/place
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param id [Integer] The {https://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. WOEIDs can be retrieved by calling {Twitter::API::Trends#trend_locations}. Global information is available by using 1 as the WOEID.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Array<Twitter::Trend>]
      # @example Return the top 10 trending topics for San Francisco
      #   Twitter.trends(2487956)
      def trends(id=1, options={})
        options[:id] = id
        response = get("/1.1/trends/place.json", options)
        obj = Object.new
        class << obj
            attr_accessor :values, :as_of, :created_at, :locations_name, :locations_woeid
        end
        obj.values = objects_from_array(Twitter::Trend, response[:body].first[:trends])
        obj.as_of = response[:body].first[:as_of]
        obj.created_at =response[:body].first[:created_at]
        obj.locations_name =response[:body].first[:locations].first[:name]
        obj.locations_woeid =response[:body].first[:locations].first[:woeid].to_s
        obj
      end
      alias local_trends trends
      alias trends_place trends

      # Return the trends and the other meta info as_of, created_at, and location_name, location_woeid
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/trends/place
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param id [Integer] The {https://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. WOEIDs can be retrieved by calling {Twitter::API::Trends#trend_locations}. Global information is available by using 1 as the WOEID.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Hash<Twitter::Trend>]
      # @example Return the top 10 trending topics for San Francisco
      #   t = Twitter.trends(2487956)
      #   t["trends"].first.name => "#sevenwordsaftersex"
      #   t["as_of"] => "2010-10-25T14:49:50Z"
      #   t["created_at"] => "2010-10-25T14:41:13Z"
      #   t["locations_name"] => "Worldwide"
      #   t["locations_woeid"] => "1"
      def trends_with_meta(id=1, options={})
        options[:id] = id
        response = get("/1.1/trends/place.json", options)
        trends_with_meta = Hash.new
        trends_with_meta["trends"] = objects_from_array(Twitter::Trend, response[:body].first[:trends])
        trends_with_meta["as_of"] = response[:body].first[:as_of]
        trends_with_meta["created_at"] =response[:body].first[:created_at]
        trends_with_meta["locations_name"] =response[:body].first[:locations].first[:name]
        trends_with_meta["locations_woeid"] =response[:body].first[:locations].first[:woeid].to_s
        return trends_with_meta
      end


      # Returns the locations that Twitter has trending topic information for
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/trends/available
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param options [Hash] A customizable set of options.
      # @return [Array<Twitter::Place>]
      # @example Return the locations that Twitter has trending topic information for
      #   Twitter.trends_available
      def trends_available(options={})
        objects_from_response(Twitter::Place, :get, "/1.1/trends/available.json", options)
      end
      alias trend_locations trends_available

      # Returns the locations that Twitter has trending topic information for, closest to a specified location.
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/trends/closest
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat If provided with a :long option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for latitude are -90.0 to +90.0 (North is positive) inclusive.
      # @option options [Float] :long If provided with a :lat option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for longitude are -180.0 to +180.0 (East is positive) inclusive.
      # @return [Array<Twitter::Place>]
      # @example Return the locations that Twitter has trending topic information for
      #   Twitter.trends_closest
      def trends_closest(options={})
        objects_from_response(Twitter::Place, :get, "/1.1/trends/closest.json", options)
      end

    end
  end
end

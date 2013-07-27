require 'twitter/api/utils'
require 'twitter/place'
require 'twitter/trend'

module Twitter
  module API
    module Trends
      include Twitter::API::Utils

      # Returns the top 10 trending topics for a specific WOEID, and as_of, created_at, and location_name, location_woeid
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/trends/place
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @param id [Integer] The {https://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. WOEIDs can be retrieved by calling {Twitter::API::Trends#trend_locations}. Global information is available by using 1 as the WOEID.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Object]
      # @example Return the top 10 trending topics for San Francisco
      #   t = Twitter.trends(2487956)
      #   t.trends.first.name => "#sevenwordsaftersex"
      #   t.as_of => "2010-10-25T14:49:50Z"
      #   t.created_at => "2010-10-25T14:41:13Z"
      #   t.locations_name => "San Francisco"
      #   t.locations_woeid => "2487956"
      def trends(id=1, options={})
        options[:id] = id
        response = get("/1.1/trends/place.json", options)
        values = objects_from_array(Twitter::Trend, response[:body].first[:trends])
        obj = Object.new
        class << obj
            attr_accessor :trends, :as_of, :created_at, :locations_name, :locations_woeid
            def populate(response, values)
              self.trends =  values
              self.as_of = response[:body].first[:as_of]
              self.created_at =response[:body].first[:created_at]
              self.locations_name =response[:body].first[:locations].first[:name]
              self.locations_woeid =response[:body].first[:locations].first[:woeid].to_s
            end
        end
        obj.populate(response, values)
        obj
      end
      alias local_trends trends
      alias trends_place trends

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

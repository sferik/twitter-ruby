module Twitter
  class Client
    module LocalTrends
      # Returns the locations that Twitter has trending topic information for.
      #
      # The response is an array of "locations" that encode the location's WOEID and some other human-readable information
      # such as a canonical name and country the location belongs in.
      #
      # A WOEID is a {http://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID}.
      #
      # @formats :json, :xml
      # @authenticated false
      # @rate_limited true
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat If provided with a :long option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for latitude is -90.0 to +90.0 (North is positive) inclusive.
      # @option options [Float] :long If provided with a :lat option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/trends/available
      def trend_locations(options={})
        response = get('trends/available', options)
        format.to_s.downcase == 'xml' ? response['locations'] : response
      end

      # Returns the top 10 trending topics for a specific WOEID, if trending information is available for it.
      #
      # The response is an array of "trend" objects that encode the name of the trending topic, the query option that can be
      # used to search for the topic on {http://search.twitter.com Twitter Search}, and the Twitter Search URL.
      #
      # This information is cached for 5 minutes. Requesting more frequently than that will not return any more data, and will
      # count against your rate limit usage.
      #
      # @formats :json, :xml
      # @authenticated false
      # @rate_limited true
      # @param woeid [Integer] The {http://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. Global information is available by using 1 as the WOEID.
      # @param options [Hash] A customizable set of options.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/trends/:woeid
      def local_trends(woeid=1, options={})
        response = get("trends/#{woeid}", options)
        format.to_s.downcase == 'xml' ? response['matching_trends'].first.trend : response.first.trends.map{|trend| trend.name}
      end
    end
  end
end

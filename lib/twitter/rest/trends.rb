require "twitter/place"
require "twitter/rest/request"
require "twitter/rest/utils"
require "twitter/trend_results"

module Twitter
  module REST
    # Methods for accessing trending topics
    module Trends
      include Twitter::REST::Utils

      # Returns the top 50 trending topics for a specific WOEID
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/trends/place
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.trends
      # @param id [Integer] The Yahoo! Where On Earth ID of the location.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' excludes hashtags.
      # @return [Array<Twitter::Trend>]
      def trends(id = 1, options = {})
        options = options.dup
        options[:id] = id
        response = perform_get("/1.1/trends/place.json", options).first
        Twitter::TrendResults.new(response)
      end
      # @!method local_trends
      #   @api public
      #   @see #trends
      alias local_trends trends
      # @!method trends_place
      #   @api public
      #   @see #trends
      alias trends_place trends

      # Returns locations with trending topic information
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/trends/available
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.trends_available
      # @param options [Hash] A customizable set of options.
      # @return [Array<Twitter::Place>]
      def trends_available(options = {})
        perform_get_with_objects("/1.1/trends/available.json", options, Twitter::Place)
      end
      # @!method trend_locations
      #   @api public
      #   @see #trends_available
      alias trend_locations trends_available

      # Returns trend locations closest to a specified location
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/trends/closest
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.trends_closest(lat: 37.7821, long: -122.4093)
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat The latitude to search around.
      # @option options [Float] :long The longitude to search around.
      # @return [Array<Twitter::Place>]
      def trends_closest(options = {})
        perform_get_with_objects("/1.1/trends/closest.json", options, Twitter::Place)
      end
    end
  end
end

require "twitter/geo_results"
require "twitter/place"
require "twitter/rest/utils"

module Twitter
  module REST
    # Methods for working with places and geo data
    module PlacesAndGeo
      include Twitter::REST::Utils

      # Returns all the information about a known place
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/geo/id/:place_id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.place('df51dec6f4ee2b2c')
      # @param place_id [String] A place in the world.
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::Place] The requested place.
      def place(place_id, options = {})
        perform_get_with_object("/1.1/geo/id/#{place_id}.json", options, Twitter::Place)
      end

      # Searches for up to 20 places that can be used as a place_id
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/geo/reverse_geocode
      # @note Delivers generalized results about geography.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.reverse_geocode(lat: 37.7821, long: -122.4093)
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat The latitude to search around.
      # @option options [Float] :long The longitude to search around.
      # @option options [String] :accuracy ('0m') A hint on the region in which to search.
      # @option options [String] :granularity ('neighborhood') Minimal granularity of place types to return.
      # @option options [Integer] :max_results A hint as to the number of results to return.
      # @return [Array<Twitter::Place>]
      def reverse_geocode(options = {})
        perform_get_with_object("/1.1/geo/reverse_geocode.json", options, Twitter::GeoResults)
      end

      # Searches for places that can be attached to a tweet
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/geo/search
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.geo_search(query: 'Twitter HQ')
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat The latitude to search around.
      # @option options [Float] :long The longitude to search around.
      # @option options [String] :query Free-form text to match against.
      # @option options [String] :ip An IP address for geolocation.
      # @option options [String] :granularity ('neighborhood') Minimal granularity of place types to return.
      # @option options [String] :accuracy ('0m') A hint on the region in which to search.
      # @option options [Integer] :max_results A hint as to the number of results to return.
      # @option options [String] :contained_within The place_id to restrict results to.
      # @return [Array<Twitter::Place>]
      def geo_search(options = {})
        perform_get_with_object("/1.1/geo/search.json", options, Twitter::GeoResults)
      end
      # @!method places_nearby
      #   @api public
      #   @see #geo_search
      alias places_nearby geo_search

      # Locates places near the given coordinates which are similar in name
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/geo/similar_places
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.similar_places(lat: 37.7821, long: -122.4093, name: 'Twitter')
      # @param options [Hash] A customizable set of options.
      # @option options [Float] :lat The latitude to search around.
      # @option options [Float] :long The longitude to search around.
      # @option options [String] :name The name a place is known as.
      # @option options [String] :contained_within The place_id to restrict results to.
      # @return [Array<Twitter::Place>]
      def similar_places(options = {})
        perform_get_with_object("/1.1/geo/similar_places.json", options, Twitter::GeoResults)
      end
      # @!method places_similar
      #   @api public
      #   @see #similar_places
      alias places_similar similar_places
    end
  end
end

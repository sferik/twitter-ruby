module Twitter

  # Handles the Twitter Geo API
  #
  # @see http://dev.twitter.com/pages/geo_dev_guidelines Geo Developer Guidelines
  class Geo
    extend ConfigHelper
    include ConnectionHelper
    include RequestHelper
    attr_reader :access_key, :access_secret, :consumer_key, :consumer_secret

    # Creates a new instance of the geo client
    #
    # @option options [String] :api_endpoint an alternative API endpoint such as Apigee
    def initialize(options={})
      @consumer_key = options[:consumer_key] || Twitter.consumer_key
      @consumer_secret = options[:consumer_secret] || Twitter.consumer_secret
      @access_key = options[:access_key] || Twitter.access_key
      @access_secret = options[:access_secret] || Twitter.access_secret
      @adapter = options[:adapter] || Twitter.adapter
      @api_endpoint = options[:api_endpoint] || Twitter.api_endpoint
      @api_version = options[:api_version] || Twitter.api_version
      @protocol = options[:protocol] || Twitter.protocol
      @user_agent = options[:user_agent] || Twitter.user_agent
    end

    # Returns all the information about a known place
    #
    # @param place_id [String] the place key, found using
    # @see http://dev.twitter.com/doc/get/geo/id/:place_id
    # @see Geo#reverse_geocode place_id can be found via Geo#reverse_geocode
    # @return <Hashie::Mash> place info
    # @authenticated false
    # @rate_limited true
    def place(place_id)
      perform_get("geo/id/#{place_id}.json")
    end

    # Search for places that can be attached to a statuses/update
    #
    # @option options [Float] lat The latitude to search around. -90 to 90
    # @option options [Float] long The longitude to search around. -180 to 180
    # @option options [String] query Free-form text to match against while executing a geo-based query, best suited for finding nearby locations by name.
    # @option options [String] ip An IP address. Used when attempting to fix geolocation based off of the user's IP address.
    # @option options [String] granularity ('city') This is the minimal granularity of place types to return and must be one of: "poi", "neighborhood", "city", "admin" or "country". Default: "city"
    # @option options [String] accuracy A hint on the "region" in which to search.
    # @option options [String] max_results A hint as to the number of results to return.
    # @option options [String] attribute Filter by Place Attributes: e.g. attribute:street_address
    # @return <Hashie::Mash> search results
    # @see http://dev.twitter.com/doc/get/geo/search
    # @authenticated false
    # @rate_limited true
    def search(options={})
      perform_get("geo/search.json", options)
    end

    # Given a latitude and a longitude, searches for up to
    # 20 places that can be used as a place_id when updating a status.
    #
    # @option options [Float] lat The latitude to search around. -90 to 90
    # @option options [Float] long The longitude to search around. -180 to 180
    # @option options [String] granularity ('city') This is the minimal granularity of place types to return and must be one of: "poi", "neighborhood", "city", "admin" or "country". Default: "city"
    # @option options [String] accuracy A hint on the "region" in which to search.
    # @option options [String] max_results A hint as to the number of results to return.
    # @return <Hashie::Mash> search results
    # @authenticated false
    # @rate_limited true
    def reverse_geocode(options={})
      perform_get("geo/reverse_geocode.json", options)
    end

    # Locates places near the given coordinates which are similar in name.
    #
    # @option options [Float] lat The latitude to search around. -90 to 90
    # @option options [Float] long The longitude to search around. -180 to 180
    # @option options [String] name The name a place is known as
    # @option options [String] contained_within place_id which you would like to restrict the search results to
    # @option options [String] attribute Filter by Place Attributes: e.g. attribute:street_address
    # @return <Hashie::Mash> search results
    # @see http://dev.twitter.com/doc/get/geo/similar_places
    # @see Geo#reverse_geocode place_id can be found via Geo#reverse_geocode
    # @authenticated false
    # @rate_limited true
    def similar_places(options={})
      perform_get("geo/similar_places.json", options)
    end

    # Creates a new place at the given latitude and longitude
    #
    # @option options [Float] lat The latitude to search around. -90 to 90
    # @option options [Float] long The longitude to search around. -180 to 180
    # @option options [String] name The name a place is known as
    # @option options [String] contained_within place_id which you would like to restrict the search results to
    # @option options [String] attribute Filter by Place Attributes: e.g. attribute:street_address
    # @option options [String] token The token returned from #similar_places
    # @return <Hashie::Mash> place info
    # @see http://dev.twitter.com/doc/post/geo/place
    # @see Geo#similar_places token can be retrieved via Geo#similar_places
    # @authenticated true
    # @rate_limited true
    def create_place(options={})
      perform_post("geo/place.json", options)
    end

  end
end

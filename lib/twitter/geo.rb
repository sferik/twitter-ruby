module Twitter
  
  # Handles the Twitter Geo API
  #
  # @see http://dev.twitter.com/pages/geo_dev_guidelines Geo Developer Guidelines
  class Geo
    extend SingleForwardable

    # Creates a new instance of the geo client
    #
    # @option options [String] :api_endpoint an alternative API endpoint such as Apigee
    def initialize(options={})
      @consumer_key = options[:consumer_key] || Twitter.consumer_key
      @consumer_secret = options[:consumer_secret] || Twitter.consumer_secret
      @access_key = options[:access_key] || Twitter.access_key
      @access_secret = options[:access_secret] || Twitter.access_secret
      
      @adapter = options.delete(:adapter)
      @api_endpoint = "api.twitter.com/#{Twitter.api_version}/geo"
      @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
      @api_endpoint = @api_endpoint.to_s
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
      results = connection.get do |request|
        request.url "id/#{place_id}.#{Twitter.format}"
      end.body
    end
    
    # Creates a new place at the given latitude and longitude.
    #

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
      results = connection.get do |request|
        request.url "search.#{Twitter.format}", options
      end.body
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
      results = connection.get do |request|
        request.url "reverse_geocode.#{Twitter.format}", options
      end.body
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
      results = connection.get do |request|
        request.url "similar_places.#{Twitter.format}", options
      end.body
    end

    # Creates a new place at the given latitude and longitude
    #
    # @option place_info [Float] lat The latitude to search around. -90 to 90
    # @option place_info [Float] long The longitude to search around. -180 to 180
    # @option place_info [String] name The name a place is known as
    # @option place_info [String] contained_within place_id which you would like to restrict the search results to
    # @option place_info [String] attribute Filter by Place Attributes: e.g. attribute:street_address
    # @option place_info [String] token The token returned from #similar_places
    # @return <Hashie::Mash> place info
    # @see http://dev.twitter.com/doc/post/geo/place
    # @see Geo#similar_places token can be retrieved via Geo#similar_places
    # @authenticated true
    # @rate_limited true
    def create_place(place_info={})
      place = connection.post do |request|
        path = "place.#{Twitter.format}"
        request.body = place_info
        request.url path
        request['Authorization'] = oauth_header(path, place_info, :post)
      end.body
    end

    # @private
    def self.client; self.new end

    def_delegators :client, :place, :search, :reverse_geocode, :similar_places, :create_place

    private

    def connection
      headers = {:user_agent => Twitter.user_agent}
      ssl = {:verify => false}
      @connection = Faraday::Connection.new(:url => @api_endpoint, :headers => headers, :ssl => ssl) do |builder|
        builder.adapter(@adapter || Faraday.default_adapter)
        builder.use Faraday::Response::RaiseErrors
        case Twitter.format.to_s
        when "json"
          builder.use Faraday::Response::ParseJson
        when "xml"
          builder.use Faraday::Response::ParseXml
        end
        builder.use Faraday::Response::Mashify
      end
      @connection.scheme = Twitter.scheme
      @connection
    end
    
    def oauth_header(path, options, method)
      oauth_params = {
        :consumer_key    => @consumer_key,
        :consumer_secret => @consumer_secret,
        :access_key      => @access_key,
        :access_secret   => @access_secret
      }
      SimpleOAuth::Header.new(method, connection.build_url(path), options, oauth_params).to_s
    end

  end
end

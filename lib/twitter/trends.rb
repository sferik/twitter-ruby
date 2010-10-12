module Twitter
  
  # Handles the Twitter trends API
  class Trends
    extend SingleForwardable

    # Returns a new instance of the Trends API client
    #
    # @option options [String] :api_endpoint an alternative API endpoint such as Apigee
    def initialize(options={})
      @adapter = options.delete(:adapter)
      @api_endpoint = "api.twitter.com/#{Twitter.api_version}/trends"
      @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
      @api_endpoint = @api_endpoint.to_s
    end

    # @group Global trends
    #
    # Returns the current top 10 trending topics on Twitter
    #
    # @option options [String] exclude Supplying 'hashtags' will remove all hashtags from the trends list
    # @return <Hashie::Mash> trends info
    # @see http://dev.twitter.com/doc/get/trends/current
    # @authenticated false
    # @rate_limited true
    def current(options={})
      results = connection.get do |request|
        request.url "current.#{Twitter.format}", options
      end.body
    end

    # Returns the top 20 trending topics for each hour in a given day
    #
    # @option options [String] date Date for which to show trends in YYYY-MM-DD format
    # @option options [String] exclude Supplying 'hashtags' will remove all hashtags from the trends list
    # @return <Hashie::Mash> trends info or 404 if date is out of range
    # @see http://dev.twitter.com/doc/get/trends/daily
    # @authenticated false
    # @rate_limited true
    def daily(options={})
      results = connection.get do |request|
        request.url "daily.#{Twitter.format}", options
      end.body
    end

    # Returns the top 30 trending topics for each hour for a given week
    #
    # @option options [String] date Beginning of week for which to show trends in YYYY-MM-DD format
    # @option options [String] exclude Supplying 'hashtags' will remove all hashtags from the trends list
    # @return <Hashie::Mash> trends info or 404 if date is out of range
    # @see http://dev.twitter.com/doc/get/trends/weekly
    # @authenticated false
    # @rate_limited true
    def weekly(options={})
      results = connection.get do |request|
        request.url "weekly.#{Twitter.format}", options
      end.body
    end

    # @group Local trends
    #
    # Returns the locations for which Twitter has trending topic information
    #
    # @option options [Float] lat The latitude to search around. -90 to 90
    # @option options [Float] long The longitude to search around. -180 to 180
    # @return [Hashie::Mash] Locations for which trends are available
    # @see http://dev.twitter.com/doc/get/trends/available
    # @see http://developer.yahoo.com/geo/geoplanet/ Yahoo! WOEID info
    # @authenticated false
    # @rate_limited true
    def available(options={})
      connection.get do |request|
        request.url "available.#{Twitter.format}", options
      end.body
    end

    # Returns the top 10 trending topics for a specific WOEID, 
    # if trending information is available for it.
    #
    # @param woeid
    # @return [Hashie::Mash] Trends for the specified location
    # @see http://dev.twitter.com/doc/get/trends/available
    # @see http://developer.yahoo.com/geo/geoplanet/ Yahoo! WOEID info
    # @authenticated false
    # @rate_limited true
    def for_location(woeid)
      connection.get do |request|
        request.url "#{woeid}.#{Twitter.format}"
      end.body
    end

    # @private
    def self.client; self.new end

    def_delegators :client, :current, :daily, :weekly, :available, :for_location

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

  end
end

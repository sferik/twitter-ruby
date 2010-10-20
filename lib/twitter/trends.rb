module Twitter

  # Handles the Twitter trends API
  class Trends
    extend ConfigHelper
    include ConnectionHelper
    include RequestHelper
    attr_reader :access_key, :access_secret, :consumer_key, :consumer_secret

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
      perform_get("trends/current.json", options)
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
      perform_get("trends/daily.json", options)
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
      perform_get("trends/weekly.json", options)
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
      perform_get("trends/available.json", options)
    end

    # Returns the top 10 trending topics for a specific WOEID,
    # if trending information is available for it.
    #
    # @param woeid
    # @return [Hashie::Mash] Trends for the specified location
    # @see http://dev.twitter.com/doc/get/trends/:woeid
    # @see http://developer.yahoo.com/geo/geoplanet/ Yahoo! WOEID info
    # @authenticated false
    # @rate_limited true
    def for_location(woeid)
      perform_get("trends/#{woeid}.json")
    end

  end
end

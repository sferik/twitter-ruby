require 'twitter/version'

module Twitter
  # Defines constants and methods related to configuration
  module Config

    # The HTTP connection adapter that will be used to connect if none is set
    DEFAULT_ADAPTER = :net_http

    # The Faraday connection options if none is set
    DEFAULT_CONNECTION_OPTIONS = {}

    # The consumer key if none is set
    DEFAULT_CONSUMER_KEY = nil

    # The consumer secret if none is set
    DEFAULT_CONSUMER_SECRET = nil

    # The endpoint that will be used to connect if none is set
    #
    # @note This is configurable in case you want to use HTTP instead of HTTPS, specify a different API version, or use a Twitter-compatible endpoint.
    # @see http://status.net/wiki/Twitter-compatible_API
    # @see http://en.blog.wordpress.com/2009/12/12/twitter-api/
    # @see http://staff.tumblr.com/post/287703110/api
    # @see http://developer.typepad.com/typepad-twitter-api/twitter-api.html
    DEFAULT_ENDPOINT = 'https://api.twitter.com'

    # The gateway server if none is set
    DEFAULT_GATEWAY = nil

    # This endpoint will be used by default when updating statuses with media
    DEFAULT_MEDIA_ENDPOINT = 'https://upload.twitter.com'

    # The oauth token if none is set
    DEFAULT_OAUTH_TOKEN = nil

    # The oauth token secret if none is set
    DEFAULT_OAUTH_TOKEN_SECRET = nil

    # The proxy server if none is set
    DEFAULT_PROXY = nil

    # The search endpoint that will be used to connect if none is set
    #
    # @note This is configurable in case you want to use HTTP instead of HTTPS or use a Twitter-compatible endpoint.
    # @see http://status.net/wiki/Twitter-compatible_API
    DEFAULT_SEARCH_ENDPOINT = 'https://search.twitter.com'

    # The value sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "Twitter Ruby Gem #{Twitter::Version}"

    # An array of valid keys in the options hash when configuring a {Twitter::Client}
    VALID_OPTIONS_KEYS = [
      :adapter,
      :connection_options,
      :consumer_key,
      :consumer_secret,
      :endpoint,
      :gateway,
      :oauth_token,
      :oauth_token_secret,
      :proxy,
      :search_endpoint,
      :user_agent,
      :media_endpoint
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter            = DEFAULT_ADAPTER
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self.endpoint           = DEFAULT_ENDPOINT
      self.gateway            = DEFAULT_GATEWAY
      self.media_endpoint     = DEFAULT_MEDIA_ENDPOINT
      self.oauth_token        = DEFAULT_OAUTH_TOKEN
      self.oauth_token_secret = DEFAULT_OAUTH_TOKEN_SECRET
      self.proxy              = DEFAULT_PROXY
      self.search_endpoint    = DEFAULT_SEARCH_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self
    end

  end
end

require 'faraday'
require File.expand_path('../version', __FILE__)

module Twitter
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {Twitter::API}
    VALID_OPTIONS_KEYS = [:consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret, :adapter, :endpoint, :format, :proxy, :search_endpoint, :user_agent].freeze

    # An array of valid request/response formats
    #
    # @note Not all methods support the XML format.
    VALID_FORMATS = [:json, :xml].freeze

    # By default, don't set an application key
    DEFAULT_CONSUMER_KEY = nil.freeze

    # By default, don't set an application secret
    DEFAULT_CONSUMER_SECRET = nil.freeze

    # By default, don't set a user oauth token
    DEFAULT_OAUTH_TOKEN = nil.freeze

    # By default, don't set a user oauth secret
    DEFAULT_OAUTH_TOKEN_SECRET = nil.freeze

    # The faraday adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter.freeze

    # The endpoint that will be used to connect if none is set
    #
    # @note This is configurable in case you want to use HTTP instead of HTTPS, specify a different API version, or use a Twitter-compatible endpoint.
    # @see http://status.net/wiki/Twitter-compatible_API
    # @see http://en.blog.wordpress.com/2009/12/12/twitter-api/
    # @see http://staff.tumblr.com/post/287703110/api
    # @see http://developer.typepad.com/typepad-twitter-api/twitter-api.html
    DEFAULT_ENDPOINT = 'https://api.twitter.com/1/'.freeze

    # The search endpoint that will be used to connect if none is set
    #
    # @note This is configurable in case you want to use HTTP instead of HTTPS or use a Twitter-compatible endpoint.
    # @see http://status.net/wiki/Twitter-compatible_API
    DEFAULT_SEARCH_ENDPOINT = 'https://search.twitter.com/'.freeze

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note JSON is preferred over XML because it is more concise and faster to parse.
    DEFAULT_FORMAT = :json.freeze

    # By default, don't use a proxy server
    DEFAULT_PROXY = nil.freeze

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT         = "Twitter Ruby Gem #{Twitter::VERSION}".freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self.oauth_token        = DEFAULT_OAUTH_TOKEN
      self.oauth_token_secret = DEFAULT_OAUTH_TOKEN_SECRET
      self.adapter            = DEFAULT_ADAPTER
      self.endpoint           = DEFAULT_ENDPOINT
      self.format             = DEFAULT_FORMAT
      self.proxy              = DEFAULT_PROXY
      self.search_endpoint    = DEFAULT_SEARCH_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self
    end
  end
end

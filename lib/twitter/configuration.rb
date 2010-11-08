require 'faraday'
require File.expand_path('../version', __FILE__)

module Twitter
  module Configuration
    # Valid keys in the options hash when configuring a {Twitter::API}
    VALID_OPTIONS_KEYS         = [:consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret, :adapter, :endpoint, :format, :proxy, :search_endpoint, :user_agent].freeze
    # Valid Twitter request/response formats
    #
    # @note Not all methods support all formats
    VALID_FORMATS              = [:json, :xml].freeze

    # The consumer key set in {Twitter::Authentication}, unless overridden
    DEFAULT_CONSUMER_KEY       = nil.freeze
    # The consumer secret set in {Twitter::Authentication}, unless overridden
    DEFAULT_CONSUMER_SECRET    = nil.freeze
    # The OAuth token set in {Twitter::Authentication}, unless overridden
    DEFAULT_OAUTH_TOKEN        = nil.freeze
    # The OAuth token secret set in {Twitter::Authentication}, unless overridden
    DEFAULT_OAUTH_TOKEN_SECRET = nil.freeze
    # The Faraday adapter set in {Twitter::Connection}, unless overridden
    DEFAULT_ADAPTER            = Faraday.default_adapter.freeze
    # The Twitter REST API endpoint set in {Twitter::Connection}, unless overridden
    DEFAULT_ENDPOINT           = 'https://api.twitter.com/1/'.freeze
    # The Twitter Search API endpoint set in {Twitter::Connection}, unless overridden
    DEFAULT_SEARCH_ENDPOINT    = 'https://search.twitter.com/'.freeze
    # The response format appended to the path in {Twitter::Request} and sent in the Accept header in {Twitter::Connection}, unless overridden
    DEFAULT_FORMAT             = :json.freeze
    # The proxy server set in {Twitter::Connection}, unless overridden
    DEFAULT_PROXY              = nil.freeze
    # The user agent set in {Twitter::Connection}, unless overridden
    DEFAULT_USER_AGENT         = "Twitter Ruby Gem #{Twitter::VERSION}".freeze

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}){|o, k| o.merge!(k => send(k))}
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter         = DEFAULT_ADAPTER
      self.endpoint        = DEFAULT_ENDPOINT
      self.search_endpoint = DEFAULT_SEARCH_ENDPOINT
      self.format          = DEFAULT_FORMAT
      self.proxy           = DEFAULT_PROXY
      self.user_agent      = DEFAULT_USER_AGENT
      self
    end
  end
end

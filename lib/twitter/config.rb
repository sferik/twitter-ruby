require 'faraday'
require 'twitter/request/multipart_with_file'
require 'twitter/response/parse_json'
require 'twitter/response/raise_client_error'
require 'twitter/response/raise_server_error'
require 'twitter/version'

module Twitter
  # Defines constants and methods related to configuration
  module Config

    # The Faraday connection options if none is set
    DEFAULT_CONNECTION_OPTIONS = {}

    # The consumer key if none is set
    DEFAULT_CONSUMER_KEY = ENV['TWITTER_CONSUMER_KEY']

    # The consumer secret if none is set
    DEFAULT_CONSUMER_SECRET = ENV['TWITTER_CONSUMER_SECRET']

    # The endpoint that will be used to connect if none is set
    #
    # @note This is configurable in case you want to use HTTP instead of HTTPS or use a Twitter-compatible endpoint.
    # @see http://status.net/wiki/Twitter-compatible_API
    # @see http://en.blog.wordpress.com/2009/12/12/twitter-api/
    # @see http://staff.tumblr.com/post/287703110/api
    # @see http://developer.typepad.com/typepad-twitter-api/twitter-api.html
    DEFAULT_ENDPOINT = 'https://api.twitter.com'

    # This endpoint will be used by default when updating statuses with media
    DEFAULT_MEDIA_ENDPOINT = 'https://upload.twitter.com'

    # The middleware stack if none is set
    #
    # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
    # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
    # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
    DEFAULT_MIDDLEWARE = Faraday::Builder.new(&Proc.new { |builder|
      builder.use Twitter::Request::MultipartWithFile   # convert file uploads to Faraday::UploadIO objects
      builder.use Faraday::Request::Multipart           # checks for files in the payload
      builder.use Faraday::Request::UrlEncoded          # convert request params as "www-form-urlencoded"
      builder.use Twitter::Response::RaiseClientError   # handle 4xx server responses
      builder.use Twitter::Response::ParseJson          # parse JSON response bodies using MultiJson
      builder.use Twitter::Response::RaiseServerError   # handle 5xx server responses
      builder.adapter Faraday.default_adapter           # set Faraday's HTTP adapter
    })

    # The oauth token if none is set
    DEFAULT_OAUTH_TOKEN = ENV['TWITTER_OAUTH_TOKEN']

    # The oauth token secret if none is set
    DEFAULT_OAUTH_TOKEN_SECRET = ENV['TWITTER_OAUTH_TOKEN_SECRET']

    # The proxy server if none is set
    DEFAULT_PROXY = nil

    # The value sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "Twitter Ruby Gem #{Twitter::Version}"

    # An array of valid keys in the options hash when configuring a {Twitter::Client}
    VALID_OPTIONS_KEYS = [
      :connection_options,
      :consumer_key,
      :consumer_secret,
      :endpoint,
      :media_endpoint,
      :middleware,
      :oauth_token,
      :oauth_token_secret,
      :proxy,
      :user_agent,
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
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self.endpoint           = DEFAULT_ENDPOINT
      self.media_endpoint     = DEFAULT_MEDIA_ENDPOINT
      self.middleware         = DEFAULT_MIDDLEWARE
      self.oauth_token        = DEFAULT_OAUTH_TOKEN
      self.oauth_token_secret = DEFAULT_OAUTH_TOKEN_SECRET
      self.proxy              = DEFAULT_PROXY
      self.user_agent         = DEFAULT_USER_AGENT
      self
    end

  end
end

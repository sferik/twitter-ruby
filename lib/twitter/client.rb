require "twitter/error"
require "twitter/utils"
require "twitter/version"

module Twitter
  # Base client class for Twitter API authentication
  class Client
    include Twitter::Utils

    # The OAuth access token
    #
    # @api public
    # @example
    #   client.access_token # => "token"
    # @return [String]
    attr_accessor :access_token

    # The OAuth access token secret
    #
    # @api public
    # @example
    #   client.access_token_secret # => "secret"
    # @return [String]
    attr_accessor :access_token_secret

    # The OAuth consumer key
    #
    # @api public
    # @example
    #   client.consumer_key # => "key"
    # @return [String]
    attr_accessor :consumer_key

    # The OAuth consumer secret
    #
    # @api public
    # @example
    #   client.consumer_secret # => "secret"
    # @return [String]
    attr_accessor :consumer_secret

    # The proxy server URI
    #
    # @api public
    # @example
    #   client.proxy # => "http://proxy.example.com:8080"
    # @return [String]
    attr_accessor :proxy

    # The HTTP request timeouts
    #
    # @api public
    # @example
    #   client.timeouts # => {connect: 5, read: 10}
    # @return [Hash]
    attr_accessor :timeouts

    # The development environment name for Premium API endpoints
    #
    # @api public
    # @example
    #   client.dev_environment # => "dev"
    # @return [String]
    attr_accessor :dev_environment

    # The user agent string sent with requests
    #
    # @api public
    # @example
    #   client.user_agent = "MyApp/1.0"
    # @return [String]
    attr_writer :user_agent

    # Initializes a new Client object
    #
    # @api public
    # @example
    #   client = Twitter::Client.new(consumer_key: "key")
    # @param options [Hash]
    # @return [Twitter::Client]
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end
      yield(self) if block_given?
    end

    # Check if user token credentials are present
    #
    # @api public
    # @example
    #   client.user_token? # => true
    # @return [Boolean]
    def user_token?
      !(blank_string?(access_token) || blank_string?(access_token_secret))
    end

    # The user agent string sent with requests
    #
    # @api public
    # @example
    #   client.user_agent # => "TwitterRubyGem/8.2.0"
    # @return [String]
    def user_agent
      @user_agent ||= "TwitterRubyGem/#{Twitter::Version}"
    end

    # The OAuth credentials hash
    #
    # @api public
    # @example
    #   client.credentials # => {consumer_key: "key", ...}
    # @return [Hash]
    def credentials
      {
        consumer_key:,
        consumer_secret:,
        token: access_token,
        token_secret: access_token_secret
      }
    end

    # Check if all credentials are present
    #
    # @api public
    # @example
    #   client.credentials? # => true
    # @return [Boolean]
    def credentials?
      credentials.values.none? { |v| blank_string?(v) }
    end

    private

    # Check if string is blank or nil
    #
    # @api private
    # @param string [String]
    # @return [Boolean]
    def blank_string?(string)
      string.respond_to?(:empty?) ? string.empty? : !string
    end
  end
end

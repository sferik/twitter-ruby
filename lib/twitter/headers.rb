require "addressable/uri"
require "base64"
require "simple_oauth"

module Twitter
  # Builds HTTP headers for Twitter API requests
  class Headers
    # Initializes a new Headers object
    #
    # @api public
    # @example
    #   Twitter::Headers.new(client, :get, "https://api.twitter.com")
    # @param client [Twitter::Client] The client making the request
    # @param request_method [Symbol] The HTTP request method
    # @param url [String] The request URL
    # @param options [Hash] Additional options
    # @return [Twitter::Headers]
    def initialize(client, request_method, url, options = {})
      @client = client
      @request_method = request_method.to_sym
      @uri = Addressable::URI.parse(url)
      @bearer_token_request = options.delete(:bearer_token_request)
      @options = options
    end

    # Check if this is a bearer token request
    #
    # @api public
    # @example
    #   headers.bearer_token_request? # => false
    # @return [Boolean]
    def bearer_token_request?
      !!@bearer_token_request
    end

    # Generate OAuth authentication header
    #
    # @api public
    # @example
    #   headers.oauth_auth_header # => #<SimpleOAuth::Header>
    # @return [SimpleOAuth::Header]
    def oauth_auth_header
      SimpleOAuth::Header.new(@request_method, @uri, @options, @client.credentials.merge(ignore_extra_keys: true))
    end

    # Build the request headers hash
    #
    # @api public
    # @example
    #   headers.request_headers # => {user_agent: "...", authorization: "..."}
    # @return [Hash]
    def request_headers
      headers = {} #: Hash[Symbol, String]
      headers[:user_agent] = @client.user_agent
      if bearer_token_request?
        headers[:accept]        = "*/*"
        headers[:authorization] = bearer_token_credentials_auth_header
      else
        headers[:authorization] = auth_header
      end
      headers
    end

  private

    # Generate the appropriate auth header based on credentials
    #
    # @api private
    # @return [String]
    def auth_header
      if @client.user_token?
        oauth_auth_header.to_s
      else
        @client.bearer_token = @client.token unless @client.bearer_token?
        bearer_auth_header
      end
    end

    # Generate a bearer auth header
    #
    # @api private
    # @return [String]
    def bearer_auth_header
      "Bearer #{@client.bearer_token}"
    end

    # Generates authentication header for a bearer token request
    #
    # @api private
    # @return [String]
    def bearer_token_credentials_auth_header
      "Basic #{Base64.strict_encode64("#{@client.consumer_key}:#{@client.consumer_secret}")}"
    end
  end
end

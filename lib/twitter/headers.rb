require 'addressable/uri'
require 'base64'
require 'simple_oauth'

module Twitter
  class Headers
    def initialize(client, request_method, url, options = {})
      @client = client
      @request_method = request_method.to_sym
      @uri = Addressable::URI.parse(url)
      @options = options
      @signature_options = @request_method == :post && @options.values.any? { |value| value.respond_to?(:to_io) } ? {} : @options
    end

    def oauth_auth_header
      SimpleOAuth::Header.new(@request_method, @uri, @signature_options, @client.credentials)
    end

    def request_headers
      bearer_token_request = @options.delete(:bearer_token_request)
      headers = {}
      if bearer_token_request
        headers[:accept]        = '*/*'
        headers[:authorization] = bearer_token_credentials_auth_header
        headers[:content_type]  = 'application/x-www-form-urlencoded; charset=UTF-8'
      else
        headers[:authorization] = auth_header
      end
      headers
    end

  private

    def auth_header
      if @client.user_token?
        oauth_auth_header.to_s
      else
        @client.bearer_token = @client.token unless @client.bearer_token?
        bearer_auth_header
      end
    end

    def bearer_auth_header
      bearer_token = @client.bearer_token
      token = bearer_token.is_a?(Twitter::Token) && bearer_token.bearer? ? bearer_token.access_token : bearer_token
      "Bearer #{token}"
    end

    # Generates authentication header for a bearer token request
    #
    # @return [String]
    def bearer_token_credentials_auth_header
      basic_auth_token = Base64.strict_encode64("#{@client.consumer_key}:#{@client.consumer_secret}")
      "Basic #{basic_auth_token}"
    end
  end
end

require 'base64'
require 'faraday'
require 'faraday/request/multipart'
require 'json'
require 'timeout'
require 'twitter/client'
require 'twitter/error'
require 'twitter/rest/api'
require 'twitter/rest/request/multipart_with_file'
require 'twitter/rest/response/parse_json'
require 'twitter/rest/response/raise_error'

module Twitter
  module REST
    # Wrapper for the Twitter REST API
    #
    # @note All methods have been separated into modules and follow the same grouping used in {http://dev.twitter.com/doc the Twitter API Documentation}.
    # @see http://dev.twitter.com/pages/every_developer
    class Client < Twitter::Client
      include Twitter::REST::API
      attr_accessor :bearer_token
      URL_PREFIX = 'https://api.twitter.com'
      ENDPOINT = URL_PREFIX

      # @param connection_options [Hash]
      # @return [Hash]
      def connection_options=(connection_options)
        warn "#{Kernel.caller.first}: [DEPRECATION] Twitter::REST::Client#connection_options= is deprecated and will be removed in version 6.0.0."
        @connection_options = connection_options
      end

      # @return [Hash]
      def connection_options
        @connection_options ||= {
          :builder => middleware,
          :headers => {
            :accept => 'application/json',
            :user_agent => user_agent,
          },
          :request => {
            :open_timeout => 10,
            :timeout => 30,
          },
          :proxy => proxy,
        }
      end

      # @params middleware [Faraday::RackBuilder]
      # @return [Faraday::RackBuilder]
      def middleware=(middleware)
        warn "#{Kernel.caller.first}: [DEPRECATION] Twitter::REST::Client#middleware= is deprecated and will be removed in version 6.0.0."
        @middleware = middleware
      end

      # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
      # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
      # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
      # @return [Faraday::RackBuilder]
      def middleware
        @middleware ||= Faraday::RackBuilder.new do |faraday|
          # Convert file uploads to Faraday::UploadIO objects
          faraday.request :twitter_multipart_with_file
          # Checks for files in the payload, otherwise leaves everything untouched
          faraday.request :multipart
          # Encodes as "application/x-www-form-urlencoded" if not already encoded
          faraday.request :url_encoded
          # Handle error responses
          faraday.response :twitter_raise_error
          # Parse JSON response bodies
          faraday.response :twitter_parse_json
          # Set default HTTP adapter
          faraday.adapter :net_http
        end
      end

      # Perform an HTTP GET request
      def get(path, params = {})
        headers = request_headers(:get, URL_PREFIX + path, params)
        request(:get, path, params, headers)
      end

      # Perform an HTTP POST request
      def post(path, params = {})
        headers = params.values.any? { |value| value.respond_to?(:to_io) } ? request_headers(:post, URL_PREFIX + path, params, {}) : request_headers(:post, URL_PREFIX + path, params)
        request(:post, path, params, headers)
      end

      # @return [Boolean]
      def bearer_token?
        !!bearer_token
      end

      # @return [Boolean]
      def credentials?
        super || bearer_token?
      end

    private

      # Returns a Faraday::Connection object
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= Faraday.new(URL_PREFIX, connection_options)
      end

      def request(method, path, params = {}, headers = {})
        connection.send(method.to_sym, path, params) { |request| request.headers.update(headers) }.env
      rescue Faraday::Error::TimeoutError, Timeout::Error => error
        raise(Twitter::Error::RequestTimeout.new(error))
      rescue Faraday::Error::ClientError, JSON::ParserError => error
        raise(Twitter::Error.new(error))
      end

      def request_headers(method, url, params = {}, signature_params = params)
        bearer_token_request = params.delete(:bearer_token_request)
        headers = {}
        if bearer_token_request
          headers[:accept]        = '*/*'
          headers[:authorization] = bearer_token_credentials_auth_header
          headers[:content_type]  = 'application/x-www-form-urlencoded; charset=UTF-8'
        else
          headers[:authorization] = auth_header(method, url, params, signature_params)
        end
        headers
      end

      def auth_header(method, url, params = {}, signature_params = params)
        if !user_token?
          @bearer_token = token unless bearer_token?
          bearer_auth_header
        else
          oauth_auth_header(method, url, signature_params).to_s
        end
      end

      # Generates authentication header for a bearer token request
      #
      # @return [String]
      def bearer_token_credentials_auth_header
        basic_auth_token = strict_encode64("#{@consumer_key}:#{@consumer_secret}")
        "Basic #{basic_auth_token}"
      end

      def bearer_auth_header
        token = bearer_token.is_a?(Twitter::Token) && bearer_token.bearer? ? bearer_token.access_token : bearer_token
        "Bearer #{token}"
      end

      # Base64.strict_encode64 is not available on Ruby 1.8.7
      def strict_encode64(str)
        Base64.encode64(str).gsub("\n", '')
      end
    end
  end
end

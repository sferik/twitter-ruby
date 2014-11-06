require 'base64'
require 'faraday'
require 'faraday/request/multipart'
require 'twitter/client'
require 'twitter/rest/api'
require 'twitter/rest/request'
require 'twitter/rest/request/multipart_with_file'
require 'twitter/rest/response/parse_json'
require 'twitter/rest/response/raise_error'
require 'twitter/rest/utils'

module Twitter
  module REST
    class Client < Twitter::Client
      include Twitter::REST::API
      URL_PREFIX = 'https://api.twitter.com'
      attr_accessor :bearer_token

      # @param connection_options [Hash]
      # @return [Hash]
      def connection_options=(connection_options)
        warn "#{Kernel.caller.first}: [DEPRECATION] #{self.class.name}##{__method__} is deprecated and will be removed."
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
        warn "#{Kernel.caller.first}: [DEPRECATION] #{self.class.name}##{__method__} is deprecated and will be removed."
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
      def get(path, options = {})
        warn "#{Kernel.caller.first}: [DEPRECATION] #{self.class.name}##{__method__} is deprecated. Use Twitter::REST::Request#perform instead."
        perform_get(path, options)
      end

      # Perform an HTTP POST request
      def post(path, options = {})
        warn "#{Kernel.caller.first}: [DEPRECATION] #{self.class.name}##{__method__} is deprecated. Use Twitter::REST::Request#perform instead."
        perform_post(path, options)
      end

      # @return [Boolean]
      def bearer_token?
        !!bearer_token
      end

      # @return [Boolean]
      def credentials?
        super || bearer_token?
      end

      # Returns a Faraday::Connection object
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= Faraday.new(URL_PREFIX, connection_options)
      end

      def request_headers(method, url, options = {}, signature_options = options)
        bearer_token_request = options.delete(:bearer_token_request)
        headers = {}
        if bearer_token_request
          headers[:accept]        = '*/*'
          headers[:authorization] = bearer_token_credentials_auth_header
          headers[:content_type]  = 'application/x-www-form-urlencoded; charset=UTF-8'
        else
          headers[:authorization] = auth_header(method, url, options, signature_options)
        end
        headers
      end

    private

      def auth_header(method, url, options = {}, signature_options = options)
        if !user_token?
          @bearer_token = token unless bearer_token?
          bearer_auth_header
        else
          oauth_auth_header(method, url, signature_options).to_s
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

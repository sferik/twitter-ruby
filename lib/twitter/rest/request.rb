require "addressable/uri"
require "http"
require "http/form_data"
require "json"
require "openssl"
require "twitter/error"
require "twitter/headers"
require "twitter/rate_limit"
require "twitter/utils"
require "twitter/rest/form_encoder"

module Twitter
  module REST
    # Handles HTTP requests to the Twitter API
    class Request # rubocop:disable Metrics/ClassLength
      include Twitter::Utils

      # The base URL for Twitter API requests
      BASE_URL = "https://api.twitter.com".freeze

      # The client making the request
      #
      # @api public
      # @example
      #   request.client # => #<Twitter::REST::Client>
      # @return [Twitter::Client]
      attr_accessor :client

      # The request headers
      #
      # @api public
      # @example
      #   request.headers # => {user_agent: "...", authorization: "..."}
      # @return [Hash]
      attr_accessor :headers

      # The request options
      #
      # @api public
      # @example
      #   request.options # => {count: 10}
      # @return [Hash]
      attr_accessor :options

      # The request path
      #
      # @api public
      # @example
      #   request.path # => "/1.1/statuses/home_timeline.json"
      # @return [String]
      attr_accessor :path

      # The rate limit information from the response
      #
      # @api public
      # @example
      #   request.rate_limit # => #<Twitter::RateLimit>
      # @return [Twitter::RateLimit]
      attr_accessor :rate_limit

      # The HTTP request method
      #
      # @api public
      # @example
      #   request.request_method # => :get
      # @return [Symbol]
      attr_accessor :request_method

      # The request URI
      #
      # @api public
      # @example
      #   request.uri # => #<Addressable::URI>
      # @return [Addressable::URI]
      attr_accessor :uri

      # Returns the HTTP verb
      #
      # @api public
      # @example
      #   request.verb # => :get
      # @return [Symbol]
      def verb
        request_method
      end

      # Initializes a new Request
      #
      # @api public
      # @example
      #   Twitter::REST::Request.new(client, :get, "/1.1/statuses/home_timeline.json")
      # @param client [Twitter::Client]
      # @param request_method [String, Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param params [Hash]
      # @return [Twitter::REST::Request]
      def initialize(client, request_method, path, options = {}, params = nil)
        @client = client
        @uri = Addressable::URI.parse(path.start_with?("http") ? path : BASE_URL + path)
        multipart_options = params || options
        set_multipart_options!(request_method, multipart_options)
        @path = uri.path
        @options = options
        @options_key = {get: :params, json_post: :json, json_put: :json, delete: :params}[request_method] || :form
        @params = params
      end

      # Performs the HTTP request and returns the response
      #
      # @api public
      # @example
      #   request.perform # => [{id: 123, text: "Hello"}]
      # @return [Array, Hash]
      def perform
        response = http_client.headers(@headers).public_send(@request_method, @uri.to_s, request_options)
        response_body = response.body.empty? ? "" : symbolize_keys!(response.parse)
        response_headers = response.headers
        fail_or_return_response_body(response.code, response_body, response_headers)
      end

    private

      # Build the request options hash
      #
      # @api private
      # @return [Hash]
      def request_options
        options = if @options_key == :form
                    {form: HTTP::FormData.create(@options, encoder: Twitter::REST::FormEncoder.method(:encode))}
                  else
                    {@options_key => @options}
                  end

        options[:params] = @params if @params
        options
      end

      # Merge multipart file data into options
      #
      # @api private
      # @param options [Hash]
      # @return [void]
      def merge_multipart_file!(options)
        key = options.delete(:key)
        file = options.delete(:file)

        options[key] = if file.is_a?(StringIO)
                         HTTP::FormData::File.new(file, content_type: "video/mp4")
                       else
                         HTTP::FormData::File.new(file, filename: File.basename(file), content_type: content_type(File.basename(file)))
                       end
      end

      # Set multipart and header options based on request method
      #
      # @api private
      # @param request_method [Symbol]
      # @param options [Hash]
      # @return [void]
      def set_multipart_options!(request_method, options)
        if %i[multipart_post json_post].include?(request_method)
          merge_multipart_file!(options) if request_method == :multipart_post
          options = {}
          @request_method = :post
        elsif request_method == :json_put
          @request_method = :put
        else
          @request_method = request_method
        end
        @headers = Twitter::Headers.new(@client, @request_method, @uri, options).request_headers
      end

      # Determine content type based on file extension
      #
      # @api private
      # @param basename [String]
      # @return [String]
      def content_type(basename)
        case basename
        when /\.gif$/i
          "image/gif"
        when /\.jpe?g/i
          "image/jpeg"
        when /\.png$/i
          "image/png"
        else
          "application/octet-stream"
        end
      end

      # Check response and return body or raise error
      #
      # @api private
      # @param code [Integer]
      # @param body [Hash, Array, String]
      # @param headers [Hash]
      # @return [Hash, Array, String]
      def fail_or_return_response_body(code, body, headers)
        error = error(code, body, headers)
        raise(error) if error

        @rate_limit = Twitter::RateLimit.new(headers)
        body
      end

      # Build error object from response
      #
      # @api private
      # @param code [Integer]
      # @param body [Hash, Array, String]
      # @param headers [Hash]
      # @return [Twitter::Error, nil]
      def error(code, body, headers)
        klass = Twitter::Error::ERRORS[code]
        if klass == Twitter::Error::Forbidden
          forbidden_error(body, headers)
        elsif !klass.nil?
          klass.from_response(body, headers)
        elsif body.is_a?(Hash) && (err = body.dig(:processing_info, :error))
          Twitter::Error::MediaError.from_processing_response(err, headers)
        end
      end

      # Build forbidden error with specific message handling
      #
      # @api private
      # @param body [Hash, Array, String]
      # @param headers [Hash]
      # @return [Twitter::Error]
      def forbidden_error(body, headers)
        error = Twitter::Error::Forbidden.from_response(body, headers)
        klass = Twitter::Error::FORBIDDEN_MESSAGES[error.message]
        if klass
          klass.from_response(body, headers)
        else
          error
        end
      end

      # Recursively symbolize hash keys
      #
      # @api private
      # @param object [Hash, Array, Object]
      # @return [Hash, Array, Object]
      def symbolize_keys!(object)
        case object
        when Array
          object.each_with_index do |val, index|
            object[index] = symbolize_keys!(val)
          end
        when Hash
          object.dup.each_key do |key|
            object[key.to_sym] = symbolize_keys!(object.delete(key))
          end
        end
        object
      end

      # Check if all timeout keys are defined
      #
      # @api private
      # @return [Boolean]
      def timeout_keys_defined
        (%i[write connect read] - (@client.timeouts&.keys || [])).empty?
      end

      # Build HTTP client with proxy and timeout settings
      #
      # @api private
      # @return [HTTP::Client, HTTP]
      def http_client
        client = @client.proxy ? HTTP.via(*proxy) : HTTP
        client = client.timeout(connect: @client.timeouts[:connect], read: @client.timeouts[:read], write: @client.timeouts[:write]) if timeout_keys_defined
        client
      end

      # Return proxy values as a compacted array
      #
      # @api private
      # @return [Array]
      def proxy
        @client.proxy.values_at(:host, :port, :username, :password).compact
      end
    end
  end
end

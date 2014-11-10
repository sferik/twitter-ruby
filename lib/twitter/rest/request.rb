require 'addressable/uri'
require 'http'
require 'json'
require 'net/https'
require 'net/http/post/multipart'
require 'openssl'
require 'twitter/error'
require 'twitter/headers'
require 'twitter/rate_limit'
require 'twitter/utils'

module Twitter
  module REST
    class Request
      include Twitter::Utils
      BASE_URL = 'https://api.twitter.com'
      attr_accessor :client, :headers, :multipart, :options, :path,
                    :rate_limit, :request_method, :uri
      alias_method :verb, :request_method
      alias_method :multipart?, :multipart

      # @param client [Twitter::Client]
      # @param request_method [String, Symbol]
      # @param path [String]
      # @param options [Hash]
      # @return [Twitter::REST::Request]
      def initialize(client, request_method, path, options = {})
        @client = client
        set_multipart_options!(request_method, options)
        @uri = Addressable::URI.parse(path.start_with?('http') ? path : BASE_URL + path)
        @path = uri.path
        @options = options
      end

      # @return [Array, Hash]
      def perform
        if multipart?
          perform_multipart_post
        else
          perform_request
        end
      end

    private

      def set_multipart_options!(request_method, options)
        if request_method.to_sym == :multipart_post
          key = options.delete(:key)
          file = options.delete(:file)
          options.merge!(key => UploadIO.new(file, mime_type(file.path), File.basename(file)))
          @request_method = :post
          @multipart = true
        else
          @request_method = request_method.to_sym
          @multipart = false
        end
      end

      def perform_request
        @headers = Twitter::Headers.new(@client, @request_method, @uri, @options).request_headers
        options_key = @request_method == :get ? :params : :form
        response = HTTP.with(@headers).public_send(@request_method, @uri.to_s, options_key => @options)
        response_body = symbolize_keys!(response.parse)
        response_headers = response.headers
        fail_or_return_response_body(response.code, response_body, response_headers)
      end

      def perform_multipart_post # rubocop:disable AbcSize
        @headers = Twitter::Headers.new(@client, @request_method, @uri, {}).request_headers
        request = Net::HTTP::Post::Multipart.new(@path, @options)
        request['User-Agent'] = @headers[:user_agent]
        request['Authorization'] = @headers[:authorization]
        http = Net::HTTP.new(@uri.host, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        response = http.start { |h| h.request(request) }
        response_body = JSON.parse(response.body, symbolize_names: true)
        response_headers = response.to_hash.each_with_object({}) { |(k, v), h| h[k] = v.first }
        fail_or_return_response_body(response.code.to_i, response_body, response_headers)
      end

      def mime_type(path)
        case path
        when /\.gif$/i
          'image/gif'
        when /\.jpe?g/i
          'image/jpeg'
        when /\.png$/i
          'image/png'
        else
          'application/octet-stream'
        end
      end

      def fail_or_return_response_body(code, body, headers)
        error = error(code, body, headers)
        fail(error) if error
        @rate_limit = Twitter::RateLimit.new(headers)
        body
      end

      def error(code, body, headers)
        klass = Twitter::Error::ERRORS[code]
        if klass == Twitter::Error::Forbidden
          forbidden_error(body, headers)
        elsif !klass.nil?
          klass.from_response(body, headers)
        end
      end

      def forbidden_error(body, headers)
        error = Twitter::Error::Forbidden.from_response(body, headers)
        klass = Twitter::Error::FORBIDDEN_MESSAGES[error.message]
        if klass
          klass.from_response(body, headers)
        else
          error
        end
      end

      def symbolize_keys!(object)
        if object.is_a?(Array)
          object.each_with_index do |val, index|
            object[index] = symbolize_keys!(val)
          end
        elsif object.is_a?(Hash)
          object.keys.each do |key|
            object[key.to_sym] = symbolize_keys!(object.delete(key))
          end
        end
        object
      end
    end
  end
end

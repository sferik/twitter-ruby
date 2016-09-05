require 'addressable/uri'
require 'faraday'
require 'json'
require 'timeout'
require 'twitter/error'
require 'twitter/headers'
require 'twitter/rate_limit'

module Twitter
  module REST
    class Request
      attr_accessor :client, :headers, :options, :rate_limit, :request_method,
                    :path, :uri
      alias verb request_method

      # @param client [Twitter::Client]
      # @param request_method [String, Symbol]
      # @param path [String]
      # @param options [Hash]
      # @return [Twitter::REST::Request]
      def initialize(client, request_method, path, options = {})
        @client = client
        @path = path
        @uri = Addressable::URI.parse(client.connection.url_prefix + path)
        set_multipart_options!(request_method, options)
        @options = options
      end

      # @return [Array, Hash]
      def perform
        begin
          response = @client.connection.send(@request_method, @path, @options) { |request| request.headers.update(@headers) }.env
        rescue Faraday::Error::TimeoutError, Timeout::Error => error
          raise(Twitter::Error::RequestTimeout.new(error))
        rescue Faraday::Error::ClientError, JSON::ParserError => error
          raise(Twitter::Error.new(error))
        end
        @rate_limit = Twitter::RateLimit.new(response.response_headers)
        response.body
      end

    private

      def merge_multipart_file!(options)
        key = options.delete(:key)
        file = options.delete(:file)

        options[key] = if file.is_a?(StringIO)
                         Faraday::UploadIO.new(file, 'video/mp4')
                       else
                         Faraday::UploadIO.new(file, mime_type(File.basename(file)))
                       end
      end

      def set_multipart_options!(request_method, options)
        if request_method == :multipart_post
          merge_multipart_file!(options)
          @request_method = :post
          @headers = Twitter::Headers.new(@client, @request_method, @uri).request_headers
        else
          @request_method = request_method
          @headers = Twitter::Headers.new(@client, @request_method, @uri, options).request_headers
        end
      end

      def mime_type(basename)
        case basename
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
    end
  end
end

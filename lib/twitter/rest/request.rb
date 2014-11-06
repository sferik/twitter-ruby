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
      alias_method :verb, :request_method

      # @param client [Twitter::Client]
      # @param request_method [String, Symbol]
      # @param path [String]
      # @param options [Hash]
      # @return [Twitter::REST::Request]
      def initialize(client, request_method, path, options = {})
        @client = client
        @request_method = request_method.to_sym
        @path = path
        @uri = Addressable::URI.parse(client.connection.url_prefix + path)
        @options = options
      end

      # @return [Array, Hash]
      def perform
        @headers = Twitter::Headers.new(@client, @request_method, @uri.to_s, @options).request_headers
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
    end
  end
end

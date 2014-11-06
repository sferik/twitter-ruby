require 'addressable/uri'
require 'http'
require 'twitter/error'
require 'twitter/headers'
require 'twitter/rate_limit'
require 'twitter/utils'

module Twitter
  module REST
    class Request
      include Twitter::Utils
      BASE_URL = 'https://api.twitter.com'
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
        @uri = Addressable::URI.parse(BASE_URL + path)
        @options = options
      end

      # @return [Array, Hash]
      def perform
        @headers = Twitter::Headers.new(@client, @request_method, @uri.to_s, @options).request_headers
        options_key = @request_method == :get ? :params : :form
        response = HTTP.with(@headers).send(@request_method, @uri.to_s, options_key => @options)
        error = error(response)
        fail(error) if error
        @rate_limit = Twitter::RateLimit.new(response.headers)
        symbolize_keys!(response.parse)
      end

    private

      def error(response)
        klass = Twitter::Error.errors[response.code]
        if klass == Twitter::Error::Forbidden
          forbidden_error(response)
        elsif !klass.nil?
          klass.from_response(response)
        end
      end

      def forbidden_error(response)
        error = Twitter::Error::Forbidden.from_response(response)
        klass = Twitter::Error.forbidden_messages[error.message]
        if klass
          klass.from_response(response)
        else
          error
        end
      end
    end
  end
end

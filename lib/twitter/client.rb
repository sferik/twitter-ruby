require 'faraday'
require 'twitter/api/account'
require 'twitter/api/activity'
require 'twitter/api/blocks'
require 'twitter/api/direct_messages'
require 'twitter/api/friendships'
require 'twitter/api/geo'
require 'twitter/api/help'
require 'twitter/api/legal'
require 'twitter/api/lists'
require 'twitter/api/notifications'
require 'twitter/api/report_spam'
require 'twitter/api/saved_searches'
require 'twitter/api/search'
require 'twitter/api/statuses'
require 'twitter/api/trends'
require 'twitter/api/users'
require 'twitter/configurable'
require 'twitter/error/client_error'
require 'twitter/rate_limit'
require 'simple_oauth'
require 'uri'

module Twitter
  # Wrapper for the Twitter REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {http://dev.twitter.com/doc the Twitter API Documentation}.
  # @see http://dev.twitter.com/pages/every_developer
  class Client
    @@rate_limited = {}
    include Twitter::API::Account
    include Twitter::API::Activity
    include Twitter::API::Blocks
    include Twitter::API::DirectMessages
    include Twitter::API::Friendships
    include Twitter::API::Geo
    include Twitter::API::Help
    include Twitter::API::Legal
    include Twitter::API::Lists
    include Twitter::API::Notifications
    include Twitter::API::ReportSpam
    include Twitter::API::SavedSearches
    include Twitter::API::Search
    include Twitter::API::Statuses
    include Twitter::API::Trends
    include Twitter::API::Users
    include Twitter::Configurable

    attr_reader :rate_limit

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Twitter::Client]
    def initialize(options={})
      Twitter::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Twitter.instance_variable_get(:"@#{key}"))
      end
      @rate_limit = Twitter::RateLimit.new
    end

    # Check whether a method is rate limited
    #
    # @raise [ArgumentError] Error raised when supplied argument is not a key in the METHOD_RATE_LIMITED hash.
    # @return [Boolean]
    # @param method [Symbol]
    def rate_limited?(method)
      method_rate_limited = @@rate_limited[method.to_sym]
      if method_rate_limited.nil?
        raise ArgumentError.new("no method `#{method}' for #{self.class}")
      end
      method_rate_limited
    end

    # Perform an HTTP DELETE request
    def delete(path, params={}, options={})
      request(:delete, path, params, options)
    end

    # Perform an HTTP GET request
    def get(path, params={}, options={})
      request(:get, path, params, options)
    end

    # Perform an HTTP POST request
    def post(path, params={}, options={})
      request(:post, path, params, options)
    end

    # Perform an HTTP UPDATE request
    def put(path, params={}, options={})
      request(:put, path, params, options)
    end

  private

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

    # Perform an HTTP request
    def request(method, path, params={}, options={})
      uri = options[:endpoint] || @endpoint
      uri = URI(uri) unless uri.respond_to?(:host)
      uri += path
      request_headers = {}
      if self.credentials?
        authorization = auth_header(method, uri, params)
        request_headers[:authorization] = authorization.to_s
      end
      connection.url_prefix = options[:endpoint] || @endpoint
      response = connection.run_request(method.to_sym, path, nil, request_headers) do |request|
        unless params.empty?
          case request.method
          when :post, :put
            request.body = params
          else
            request.params.update(params)
          end
        end
        yield request if block_given?
      end.env
      @rate_limit.update(response[:response_headers])
      response
    rescue Faraday::Error::ClientError
      raise Twitter::Error::ClientError
    end

    def auth_header(method, uri, params={})
      # When posting a file, don't sign any params
      signature_params = [:post, :put].include?(method.to_sym) && params.values.any?{|value| value.is_a?(File) || (value.is_a?(Hash) && (value[:io].is_a?(IO) || value[:io].is_a?(StringIO)))} ? {} : params
      SimpleOAuth::Header.new(method, uri, signature_params, credentials)
    end

  end
end

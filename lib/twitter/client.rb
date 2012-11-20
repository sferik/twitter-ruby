require 'faraday'
require 'multi_json'
require 'twitter/api/direct_messages'
require 'twitter/api/favorites'
require 'twitter/api/friends_and_followers'
require 'twitter/api/help'
require 'twitter/api/lists'
require 'twitter/api/places_and_geo'
require 'twitter/api/saved_searches'
require 'twitter/api/search'
require 'twitter/api/spam_reporting'
require 'twitter/api/suggested_users'
require 'twitter/api/timelines'
require 'twitter/api/trends'
require 'twitter/api/tweets'
require 'twitter/api/undocumented'
require 'twitter/api/users'
require 'twitter/configurable'
require 'twitter/error/client_error'
require 'twitter/error/decode_error'
require 'simple_oauth'
require 'uri'

module Twitter
  # Wrapper for the Twitter REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {http://dev.twitter.com/doc the Twitter API Documentation}.
  # @see http://dev.twitter.com/pages/every_developer
  class Client
    include Twitter::API
    include Twitter::API::DirectMessages
    include Twitter::API::Favorites
    include Twitter::API::FriendsAndFollowers
    include Twitter::API::Help
    include Twitter::API::Lists
    include Twitter::API::PlacesAndGeo
    include Twitter::API::SavedSearches
    include Twitter::API::Search
    include Twitter::API::SpamReporting
    include Twitter::API::SuggestedUsers
    include Twitter::API::Timelines
    include Twitter::API::Trends
    include Twitter::API::Tweets
    include Twitter::API::Undocumented
    include Twitter::API::Users
    include Twitter::Configurable

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Twitter::Client]
    def initialize(options={})
      Twitter::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Twitter.instance_variable_get(:"@#{key}"))
      end
    end

    # Perform an HTTP DELETE request
    def delete(path, params={})
      request(:delete, path, params)
    end

    # Perform an HTTP GET request
    def get(path, params={})
      request(:get, path, params)
    end

    # Perform an HTTP POST request
    def post(path, params={})
      request(:post, path, params)
    end

    # Perform an HTTP UPDATE request
    def put(path, params={})
      request(:put, path, params)
    end

  private

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

    # Perform an HTTP request
    #
    # @raise [Twitter::Error::ClientError, Twitter::Error::DecodeError]
    def request(method, path, params={})
      uri = URI(@endpoint) unless uri.respond_to?(:host)
      uri += path
      request_headers = {}
      if credentials?
        authorization = auth_header(method, uri, params)
        request_headers[:authorization] = authorization.to_s
      end
      connection.url_prefix = @endpoint
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
      response
    rescue Faraday::Error::ClientError
      raise Twitter::Error::ClientError
    rescue MultiJson::DecodeError
      raise Twitter::Error::DecodeError
    end

    def auth_header(method, uri, params={})
      # When posting a file, don't sign any params
      signature_params = [:post, :put].include?(method.to_sym) && params.values.any?{|value| value.respond_to?(:to_io)} ? {} : params
      SimpleOAuth::Header.new(method, uri, signature_params, credentials)
    end

  end
end

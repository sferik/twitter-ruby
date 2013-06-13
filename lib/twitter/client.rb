require 'faraday'
require 'multi_json'
require 'twitter/api/direct_messages'
require 'twitter/api/favorites'
require 'twitter/api/friends_and_followers'
require 'twitter/api/help'
require 'twitter/api/lists'
require 'twitter/api/oauth'
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
    include Twitter::API::DirectMessages
    include Twitter::API::Favorites
    include Twitter::API::FriendsAndFollowers
    include Twitter::API::Help
    include Twitter::API::Lists
    include Twitter::API::OAuth
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
      signature_params = params.values.any?{|value| value.respond_to?(:to_io)} ? {} : params
      request(:post, path, params, signature_params)
    end

    # Perform an HTTP PUT request
    def put(path, params={})
      request(:put, path, params)
    end

  private

    # Returns a proc that can be used to setup the Faraday::Request headers
    #
    # @param method [Symbol]
    # @param path [String]
    # @param params [Hash]
    # @return [Proc]
    def request_setup(method, path, params, signature_params)
      Proc.new do |request|
        if params.delete(:bearer_token_request)
          request.headers[:authorization] = bearer_token_credentials_auth_header
          request.headers[:content_type] = 'application/x-www-form-urlencoded; charset=UTF-8'
          request.headers[:accept] = '*/*' # It is important we set this, otherwise we get an error.
        elsif params.delete(:app_auth) || !user_token?
          unless bearer_token?
            @bearer_token = token
            Twitter.client.bearer_token = @bearer_token if Twitter.client?
          end
          request.headers[:authorization] = bearer_auth_header
        else
          request.headers[:authorization] = oauth_auth_header(method, path, signature_params).to_s
        end
      end
    end

    def request(method, path, params={}, signature_params=params)
      request_setup = request_setup(method, path, params, signature_params)
      connection.send(method.to_sym, path, params, &request_setup).env
    rescue Faraday::Error::ClientError
      raise Twitter::Error::ClientError
    rescue MultiJson::DecodeError
      raise Twitter::Error::DecodeError
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

    # Generates authentication header for a bearer token request
    #
    # @return [String]
    def bearer_token_credentials_auth_header
      basic_auth_token = encode_value("#{@consumer_key}:#{@consumer_secret}")
      "Basic #{basic_auth_token}"
    end

    def encode_value(value)
      [value].pack("m0").gsub("\n", '')
    end

    def bearer_auth_header
      if @bearer_token.is_a?(Twitter::Token) && @bearer_token.token_type == "bearer"
        "Bearer #{@bearer_token.access_token}"
      else
        "Bearer #{@bearer_token}"
      end
    end

    def oauth_auth_header(method, path, params={})
      uri = URI(@endpoint + path)
      SimpleOAuth::Header.new(method, uri, params, credentials)
    end
  end
end

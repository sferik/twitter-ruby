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
require 'base64'
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
    def request_setup(method, path, params)
      if params.delete :bearer_token_request
        Proc.new do |request|
          request.headers[:authorization] = bearer_token_credentials_auth_header
          request.headers[:content_type] = 'application/x-www-form-urlencoded; charset=UTF-8'
          request.headers[:accept] = '*/*' # It is important we set this, otherwise we get an error.
        end
      elsif application_only_auth?
        Proc.new do |request|
          request.headers[:authorization] = bearer_auth_header
        end
      else
        Proc.new do |request|
          request.headers[:authorization] = oauth_auth_header(method, path, params).to_s
        end
      end
    end

    def request(method, path, params={}, signature_params=params)
      request_setup = request_setup(method, path, params)
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
      @connection ||= begin
        connection_options = {:builder => @middleware}
        connection_options[:ssl] = {:verify => true} if @endpoint[0..4] == 'https'
        Faraday.new(@endpoint, @connection_options.merge(connection_options))
      end
    end

    # Generates authentication header for a bearer token request
    #
    # @return [String]
    def bearer_token_credentials_auth_header
      basic_auth_token = Base64.strict_encode64("#{@consumer_key}:#{@consumer_secret}")
      "Basic #{basic_auth_token}"
    end

    def bearer_auth_header
      "Bearer #{@bearer_token}"
    end

    def oauth_auth_header(method, path, params={})
      uri = URI(@endpoint + path)
      SimpleOAuth::Header.new(method, uri, params, credentials)
    end
  end
end

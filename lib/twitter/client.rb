require 'base64'
require 'faraday'
require 'faraday/request/multipart'
require 'json'
require 'simple_oauth'
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
require 'twitter/error'
require 'twitter/error/configuration_error'
require 'twitter/request/multipart_with_file'
require 'twitter/response/parse_json'
require 'twitter/response/raise_error'
require 'twitter/version'
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

    attr_writer :bearer_token, :connection_options, :consumer_key,
      :consumer_secret, :endpoint, :middleware, :oauth_token,
      :oauth_token_secret

    ENDPOINT = 'https://api.twitter.com'

    # @return [String]
    def consumer_key
      @consumer_key || ENV['TWITTER_CONSUMER_KEY']
    end

    # @return [String]
    def consumer_secret
      @consumer_secret || ENV['TWITTER_CONSUMER_SECRET']
    end

    # @return [String]
    def oauth_token
      @oauth_token || ENV['TWITTER_oauth_token']
    end

    # @return [String]
    def oauth_token_secret
      @oauth_token_secret || ENV['TWITTER_oauth_token_SECRET']
    end

    # @return [String]
    def bearer_token
      @bearer_token || ENV['TWITTER_BEARER_TOKEN']
    end

    def connection_options
      @connection_options ||= {
        :headers => {
          :accept => 'application/json',
          :user_agent => "Twitter Ruby Gem #{Twitter::Version}",
        },
        :request => {
          :open_timeout => 5,
          :timeout => 10,
        },
      }
    end

    # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
    # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
    # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
    # @return [Faraday::Builder]
    def middleware
      @middleware ||= Faraday::Builder.new do |builder|
        # Convert file uploads to Faraday::UploadIO objects
        builder.use Twitter::Request::MultipartWithFile
        # Checks for files in the payload
        builder.use Faraday::Request::Multipart
        # Convert request params to "www-form-urlencoded"
        builder.use Faraday::Request::UrlEncoded
        # Handle error responses
        builder.use Twitter::Response::RaiseError, Twitter::Error
        # Parse JSON response bodies
        builder.use Twitter::Response::ParseJson
        # Set Faraday's HTTP adapter
        builder.adapter Faraday.default_adapter
      end
    end

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Twitter::Client]
    def initialize(options={})
      options.each do |key, value|
        send(:"#{key}=", value)
      end
      yield self if block_given?
      validate_credential_type!
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

    # @return [Boolean]
    def user_token?
      !!(oauth_token && oauth_token_secret)
    end

    # @return [Boolean]
    def bearer_token?
      !!bearer_token
    end

    # @return [Hash]
    def credentials
      {
        :consumer_key    => consumer_key,
        :consumer_secret => consumer_secret,
        :token           => oauth_token,
        :token_secret    => oauth_token_secret,
      }
    end

    # @return [Boolean]
    def credentials?
      credentials.values.all? || bearer_token?
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
          @bearer_token = token unless bearer_token?
          request.headers[:authorization] = bearer_auth_header
        else
          request.headers[:authorization] = oauth_auth_header(method, path, signature_params).to_s
        end
      end
    end

    def request(method, path, params={}, signature_params=params)
      request_setup = request_setup(method, path, params, signature_params)
      connection.send(method.to_sym, path, params, &request_setup).env
    rescue Faraday::Error::ClientError, JSON::ParserError
      raise Twitter::Error
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(ENDPOINT, connection_options.merge(:builder => middleware))
    end

    # Generates authentication header for a bearer token request
    #
    # @return [String]
    def bearer_token_credentials_auth_header
      basic_auth_token = Base64.strict_encode64("#{@consumer_key}:#{@consumer_secret}")
      "Basic #{basic_auth_token}"
    end

    def bearer_auth_header
      if bearer_token.is_a?(Twitter::Token) && bearer_token.token_type == "bearer"
        "Bearer #{bearer_token.access_token}"
      else
        "Bearer #{bearer_token}"
      end
    end

    def oauth_auth_header(method, path, params={})
      uri = ::URI.parse(ENDPOINT + path)
      SimpleOAuth::Header.new(method, uri, params, credentials)
    end

    # Ensures that all credentials set during configuration are of a
    # valid type. Valid types are String and Symbol.
    #
    # @raise [Twitter::Error::ConfigurationError] Error is raised when
    #   supplied twitter credentials are not a String or Symbol.
    def validate_credential_type!
      credentials.each do |credential, value|
        next if value.nil?
        raise(Error::ConfigurationError, "Invalid #{credential} specified: #{value.inspect} must be a string or symbol.") unless value.is_a?(String) || value.is_a?(Symbol)
      end
    end

  end
end

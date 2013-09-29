require 'base64'
require 'faraday'
require 'faraday/request/multipart'
require 'json'
require 'twitter/client'
require 'twitter/error'
require 'twitter/error/configuration_error'
require 'twitter/rest/api/direct_messages'
require 'twitter/rest/api/favorites'
require 'twitter/rest/api/friends_and_followers'
require 'twitter/rest/api/help'
require 'twitter/rest/api/lists'
require 'twitter/rest/api/oauth'
require 'twitter/rest/api/places_and_geo'
require 'twitter/rest/api/saved_searches'
require 'twitter/rest/api/search'
require 'twitter/rest/api/spam_reporting'
require 'twitter/rest/api/suggested_users'
require 'twitter/rest/api/timelines'
require 'twitter/rest/api/trends'
require 'twitter/rest/api/tweets'
require 'twitter/rest/api/undocumented'
require 'twitter/rest/api/users'
require 'twitter/rest/request/multipart_with_file'
require 'twitter/rest/response/parse_json'
require 'twitter/rest/response/raise_error'

module Twitter
  module REST
    # Wrapper for the Twitter REST API
    #
    # @note All methods have been separated into modules and follow the same grouping used in {http://dev.twitter.com/doc the Twitter API Documentation}.
    # @see http://dev.twitter.com/pages/every_developer
    class Client < Twitter::Client
      include Twitter::REST::API::DirectMessages
      include Twitter::REST::API::Favorites
      include Twitter::REST::API::FriendsAndFollowers
      include Twitter::REST::API::Help
      include Twitter::REST::API::Lists
      include Twitter::REST::API::OAuth
      include Twitter::REST::API::PlacesAndGeo
      include Twitter::REST::API::SavedSearches
      include Twitter::REST::API::Search
      include Twitter::REST::API::SpamReporting
      include Twitter::REST::API::SuggestedUsers
      include Twitter::REST::API::Timelines
      include Twitter::REST::API::Trends
      include Twitter::REST::API::Tweets
      include Twitter::REST::API::Undocumented
      include Twitter::REST::API::Users
      attr_accessor :bearer_token
      attr_writer :connection_options, :middleware
      ENDPOINT = 'https://api.twitter.com'

      def connection_options
        @connection_options ||= {
          :builder => middleware,
          :headers => {
            :accept => 'application/json',
            :user_agent => user_agent,
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
          builder.use Twitter::REST::Request::MultipartWithFile
          # Checks for files in the payload
          builder.use Faraday::Request::Multipart
          # Convert request params to "www-form-urlencoded"
          builder.use Faraday::Request::UrlEncoded
          # Handle error responses
          builder.use Twitter::REST::Response::RaiseError
          # Parse JSON response bodies
          builder.use Twitter::REST::Response::ParseJson
          # Set Faraday's HTTP adapter
          builder.adapter Faraday.default_adapter
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

      # @return [Boolean]
      def bearer_token?
        !!bearer_token
      end

      # @return [Boolean]
      def credentials?
        super || bearer_token?
      end

    private

      # Returns a Faraday::Connection object
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= Faraday.new(ENDPOINT, connection_options)
      end

      def request(method, path, params={}, signature_params=params)
        response = connection.send(method.to_sym, path, params) do |request|
          bearer_token_request = params.delete(:bearer_token_request)
          if bearer_token_request
            request.headers[:accept] = '*/*' # It is important we set this, otherwise we get an error.
            request.headers[:authorization] = bearer_token_credentials_auth_header
            request.headers[:content_type] = 'application/x-www-form-urlencoded; charset=UTF-8'
          else
            request.headers[:authorization] = auth_token(method, path, params, signature_params)
          end
        end
        response.env
      rescue Faraday::Error::ClientError, JSON::ParserError
        raise Twitter::Error
      end

      def auth_token(method, path, params={}, signature_params=params)
        if !user_token?
          @bearer_token = token unless bearer_token?
          bearer_auth_header
        else
          oauth_auth_header(method, ENDPOINT + path, signature_params).to_s
        end
      end

      # Generates authentication header for a bearer token request
      #
      # @return [String]
      def bearer_token_credentials_auth_header
        basic_auth_token = strict_encode64("#{@consumer_key}:#{@consumer_secret}")
        "Basic #{basic_auth_token}"
      end

      def bearer_auth_header
        token = bearer_token.is_a?(Twitter::Token) && bearer_token.bearer? ? bearer_token.access_token : bearer_token
        "Bearer #{token}"
      end

      # Base64.strict_encode64 is not available on Ruby 1.8.7
      def strict_encode64(str)
        Base64.encode64(str).gsub("\n", "")
      end

    end
  end
end

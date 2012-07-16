require 'faraday'
require 'twitter/configurable'
require 'twitter/identity_map'
require 'twitter/request/multipart_with_file'
require 'twitter/response/parse_json'
require 'twitter/response/raise_client_error'
require 'twitter/response/raise_server_error'
require 'twitter/response/rate_limit'
require 'twitter/version'

module Twitter
  module Default
    class << self

      def options
        Hash[Twitter::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # @note This is configurable in case you want to use HTTP instead of HTTPS or use a Twitter-compatible endpoint.
      # @see http://status.net/wiki/Twitter-compatible_API
      # @see http://en.blog.wordpress.com/2009/12/12/twitter-api/
      # @see http://staff.tumblr.com/post/287703110/api
      # @see http://developer.typepad.com/typepad-twitter-api/twitter-api.html
      def endpoint
        @endpoint ||= 'https://api.twitter.com'
      end

      def media_endpoint
        @media_endpoint ||= 'https://upload.twitter.com'
      end

      def search_endpoint
        @search_endpoint ||= 'https://search.twitter.com'
      end

      def connection_options
        @connection_options ||= {
          :headers => {
            :accept => 'application/json',
            :user_agent => "Twitter Ruby Gem #{Twitter::Version}"
          },
          :open_timeout => 5,
          :raw => true,
          :ssl => {:verify => false},
          :timeout => 10,
        }
      end

      # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
      # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
      # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
      def middleware
        @middleware ||= Faraday::Builder.new(
          &Proc.new do |builder|
            builder.use Twitter::Request::MultipartWithFile # Convert file uploads to Faraday::UploadIO objects
            builder.use Faraday::Request::Multipart         # Checks for files in the payload
            builder.use Faraday::Request::UrlEncoded        # Convert request params as "www-form-urlencoded"
            builder.use Twitter::Response::RaiseClientError # Handle 4xx server responses
            builder.use Twitter::Response::ParseJson        # Parse JSON response bodies using MultiJson
            builder.use Twitter::Response::RaiseServerError # Handle 5xx server responses
            builder.use Twitter::Response::RateLimit        # Update RateLimit object
            builder.adapter Faraday.default_adapter         # Set Faraday's HTTP adapter
          end
        )
      end

      def identity_map
        @identity_map ||= Twitter::IdentityMap.new({})
      end

      def consumer_key
        ENV['TWITTER_CONSUMER_KEY']
      end

      def consumer_secret
        ENV['TWITTER_CONSUMER_SECRET']
      end

      def oauth_token
        ENV['TWITTER_OAUTH_TOKEN']
      end

      def oauth_token_secret
        ENV['TWITTER_OAUTH_TOKEN_SECRET']
      end

    end
  end
end

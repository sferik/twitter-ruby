require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'
require 'faraday/multipart'
require 'faraday/oauth'
require 'faraday/raise_http_4xx'
require 'faraday/raise_http_5xx'
require 'simple_oauth'
require 'twitter/version'

module Twitter

  class << self
    attr_accessor :consumer_key, :consumer_secret, :access_key, :access_secret

    # config/initializers/twitter.rb (for instance)
    #
    # Twitter.configure do |config|
    #   config.consumer_key = 'ctoken'
    #   config.consumer_secret = 'csecret'
    #   config.access_key = 'atoken'
    #   config.access_secret = 'asecret'
    # end
    def configure
      yield self
      true
    end
  end

  module ConfigHelper
    def adapter
      @adapter ||= default_adapter
    end

    def adapter=(value)
      @adapter = value
    end

    def default_adapter
      Faraday.default_adapter.freeze
    end

    def api_endpoint
      @api_endpoint ||= default_api_endpoint
    end

    def api_endpoint=(value)
      @api_endpoint = Addressable::URI.heuristic_parse(value).to_s
    end

    def default_api_endpoint
      Addressable::URI.heuristic_parse("api.twitter.com/#{api_version}").to_s.freeze
    end

    def api_version
      @api_version ||= default_api_version
    end

    def api_version=(value)
      @api_version = value
    end

    def default_api_version
      1.freeze
    end

    def format
      @format ||= default_format
    end

    def format=(value)
      @format = value
    end

    def default_format
      'json'.freeze
    end

    def protocol
      @protocol ||= default_protocol
    end

    def protocol=(value)
      @protocol = value
    end

    def default_protocol
      'https'.freeze
    end

    def user_agent
      @user_agent ||= default_user_agent
    end

    def user_agent=(value)
      @user_agent = value
    end

    def default_user_agent
      "Twitter Ruby Gem/#{Twitter::VERSION}".freeze
    end
  end

  extend ConfigHelper

  module ConnectionHelper
    def connection
      base_connection do |builder|
        builder.use Faraday::Response::RaiseHttp5xx
        builder.use Faraday::Response::Parse
        builder.use Faraday::Response::RaiseHttp4xx
        builder.use Faraday::Response::Mashify
      end
    end

    def connection_with_unparsed_response
      base_connection do |builder|
        builder.use Faraday::Response::RaiseHttp5xx
        builder.use Faraday::Response::RaiseHttp4xx
      end
    end

    def base_connection(&block)
      headers = {:user_agent => self.class.user_agent}
      ssl = {:verify => false}
      oauth = {:consumer_key => @consumer_key, :consumer_secret => @consumer_secret, :token => @access_key, :token_secret => @access_secret}
      Faraday::Connection.new(:url => self.class.api_endpoint, :headers => headers, :ssl => ssl) do |connection|
        connection.scheme = self.class.protocol
        connection.use Faraday::Request::Multipart
        connection.use Faraday::Request::OAuth, oauth
        connection.adapter(self.class.adapter)
        yield connection if block_given?
      end
    end
  end

  module RequestHelper
    def perform_get(path, options={})
      connection.get do |request|
        request.url(path, options)
      end.body
    end

    def perform_post(path, options={})
      connection.post do |request|
        request.path = path
        request.body = options
      end.body
    end

    def perform_put(path, options={})
      connection.put do |request|
        request.path = path
        request.body = options
      end.body
    end

    def perform_delete(path, options={})
      connection.delete do |request|
        request.url(path, options)
      end.body
    end
  end

  class BadRequest < StandardError; end
  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class NotAcceptable < StandardError; end
  class InternalServerError < StandardError; end
  class BadGateway < StandardError; end
  class ServiceUnavailable < StandardError; end

  class EnhanceYourCalm < StandardError
    def initialize(message, http_headers)
      @http_headers = Hash[http_headers]
      super message
    end

    # Returns number of seconds the application should wait before requesting data from the Search API again.
    def retry_after
      retry_after = @http_headers["retry-after"] || @http_headers["Retry-After"]
      retry_after.to_i
    end
  end

end

require 'twitter/authenticated'
require 'twitter/geo'
require 'twitter/search'
require 'twitter/trends'
require 'twitter/unauthenticated'

require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'
require 'faraday/raise_http_4xx'
require 'faraday/raise_http_5xx'
require 'forwardable'
require 'simple_oauth'

module Twitter
  extend SingleForwardable
  def_delegators :client, :firehose, :user, :suggestions, :retweeted_to_user, :retweeted_by_user, :status, :friend_ids, :follower_ids, :timeline, :lists_subscribed, :list_timeline, :profile_image

  class << self
    attr_accessor :consumer_key, :consumer_secret, :access_key, :access_secret
    def client; Twitter::Unauthenticated.new end

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
      @default_adapter ||= Faraday.default_adapter
    end

    def api_endpoint
      @api_endpoint ||= default_api_endpoint
    end

    def api_endpoint=(value)
      @api_endpoint = Addressable::URI.heuristic_parse(value).to_s
    end

    def default_api_endpoint
      @default_api_endpoint ||= Addressable::URI.heuristic_parse("api.twitter.com/#{api_version}").to_s
    end

    def api_version
      @api_version ||= default_api_version
    end

    def api_version=(value)
      @api_version = value
    end

    def default_api_version
      @default_api_version ||= 1
    end

    def format
      @format ||= default_format
    end

    def format=(value)
      @format = value
    end

    def default_format
      @default_format ||= 'json'
    end

    def protocol
      @protocol ||= default_protocol
    end

    def protocol=(value)
      @protocol = value
    end

    def default_protocol
      @default_protocol ||= 'https'
    end

    def user_agent
      @user_agent ||= default_user_agent
    end

    def user_agent=(value)
      @user_agent = value
    end

    def default_user_agent
      @default_user_agent ||= 'Twitter Ruby Gem'
    end
  end

  extend ConfigHelper

  module ConnectionHelper
    def connection
      builders = []
      builders << Faraday::Response::RaiseHttp5xx
      case Twitter.format.to_s
      when "json"
        builders << Faraday::Response::ParseJson
      when "xml"
        builders << Faraday::Response::ParseXml
      end
      builders << Faraday::Response::RaiseHttp4xx
      builders << Faraday::Response::Mashify
      connection_with_builders(builders)
    end

    def connection_with_unparsed_response
      builders = []
      builders << Faraday::Response::RaiseHttp5xx
      builders << Faraday::Response::RaiseHttp4xx
      connection_with_builders(builders)
    end

    def connection_with_builders(builders)
      headers = {:user_agent => user_agent}
      ssl = {:verify => false}
      connection = Faraday::Connection.new(:url => api_endpoint, :headers => headers, :ssl => ssl) do |builder|
        builder.adapter(adapter)
        builders.each{|b| builder.use b}
      end
      connection.scheme = protocol
      connection
    end
  end

  module RequestHelper
    def oauth_header(path, options, method)
      oauth_params = {
        :consumer_key    => @consumer_key,
        :consumer_secret => @consumer_secret,
        :token           => @access_key,
        :token_secret    => @access_secret
      }
      SimpleOAuth::Header.new(method, self.class.connection.build_url(path), options, oauth_params).to_s
    end

    def perform_get(path, options={})
      results = self.class.connection.get do |request|
        request.url(path, options)
        request['Authorization'] = oauth_header(path, options, :get)
      end.body
    end

    def perform_post(path, options={})
      results = self.class.connection.post do |request|
        request.path = path
        request.body = options
        request['Authorization'] = oauth_header(path, options, :post)
      end.body
    end

    def perform_put(path, options={})
      results = self.class.connection.put do |request|
        request.path = path
        request.body = options
        request['Authorization'] = oauth_header(path, options, :put)
      end.body
    end

    def perform_delete(path, options={})
      results = self.class.connection.delete do |request|
        request.url(path, options)
        request['Authorization'] = oauth_header(path, options, :delete)
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
    def waiting_time
      header_value = @http_headers["retry-after"] || @http_headers["Retry-After"]
      header_value.to_i
    end
  end

end

require 'twitter/authenticated'
require 'twitter/geo'
require 'twitter/search'
require 'twitter/trends'
require 'twitter/unauthenticated'

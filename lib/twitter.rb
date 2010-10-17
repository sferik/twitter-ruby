require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'
require 'faraday/raise_http_4xx'
require 'faraday/raise_http_5xx'
require 'forwardable'
require 'simple_oauth'
require 'twitter/authenticated'
require 'twitter/geo'
require 'twitter/search'
require 'twitter/trends'
require 'twitter/unauthenticated'

module Twitter

  extend SingleForwardable

  def_delegators :client, :firehose, :user, :suggestions, :retweeted_to_user, :retweeted_by_user, :status, :friend_ids, :follower_ids, :timeline, :lists_subscribed, :list_timeline, :profile_image

  class << self
    attr_accessor :consumer_key
    attr_accessor :consumer_secret
    attr_accessor :access_key
    attr_accessor :access_secret

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

    def client; Twitter::Unauthenticated.new end

    def adapter
      @adapter ||= Faraday.default_adapter
    end

    def adapter=(value)
      @adapter = value
    end

    def user_agent
      @user_agent ||= 'Ruby Twitter Gem'
    end

    def user_agent=(value)
      @user_agent = value
    end

    def format
      @format ||= 'json'
    end

    def format=(value)
      @format = value
    end

    def protocol
      @protocol ||= 'https'
    end

    def protocol=(value)
      @protocol = value
    end

    def api_endpoint
      @api_endpoint ||= Addressable::URI.heuristic_parse("api.twitter.com/#{api_version}").to_s
    end

    def api_endpoint=(value)
      @api_endpoint = Addressable::URI.heuristic_parse(value).to_s
    end

    def api_version
      @api_version ||= 1
    end

    def api_version=(value)
      @api_version = value
    end
  end

  class BadRequest < StandardError; end
  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class NotAcceptable < StandardError; end
  class EnhanceYourCalm < StandardError; end
  class InternalServerError < StandardError; end
  class BadGateway < StandardError; end
  class ServiceUnavailable < StandardError; end

end

require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'
require 'forwardable'
require 'simple_oauth'
require 'cgi'

module Twitter
  extend SingleForwardable

  class BadRequest < StandardError; end
  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class NotAcceptable < StandardError; end
  class EnhanceYourCalm < StandardError; end
  class InternalServerError < StandardError; end
  class BadGateway < StandardError; end
  class ServiceUnavailable < StandardError; end

  def self.client; Twitter::Unauthenticated.new end

  def_delegators :client, :firehose, :user, :suggestions, :retweeted_to_user, :retweeted_by_user, :status, :friend_ids, :follower_ids, :timeline, :lists_subscribed, :list_timeline, :profile_image

  def self.adapter
    @adapter ||= Faraday.default_adapter
  end

  def self.adapter=(value)
    @adapter = value
  end

  def self.user_agent
    @user_agent ||= 'Ruby Twitter Gem'
  end

  def self.user_agent=(value)
    @user_agent = value
  end

  def self.format
    @format ||= 'json'
  end

  def self.format=(value)
    @format = value
  end

  def self.scheme
    @scheme ||= 'https'
  end

  def self.scheme=(value)
    @scheme = value
  end

  def self.api_endpoint
    api_endpoint = "api.twitter.com/#{Twitter.api_version}"
    api_endpoint = Addressable::URI.heuristic_parse(api_endpoint).to_s
    @api_endpoint ||= api_endpoint
  end

  def self.api_endpoint=(value)
    @api_endpoint = Addressable::URI.heuristic_parse(value).to_s
  end

  def self.api_version
    @api_version ||= 1
  end

  def self.api_version=(value)
    @api_version = value
  end

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

  end
end

faraday_middleware_files = Dir[File.join(File.dirname(__FILE__), "/faraday/**/*.rb")].sort
faraday_middleware_files.each do |file|
  require file
end

library_files = Dir[File.join(File.dirname(__FILE__), "/twitter/**/*.rb")].sort
library_files.each do |file|
  require file
end

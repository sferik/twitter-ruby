require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'
require 'forwardable'
require 'roauth'
require 'cgi'

module Twitter
  extend SingleForwardable

  def self.client; Twitter::Unauthenticated.new end

  def_delegators :client, :firehose, :user, :suggestions, :retweeted_to_user, :retweeted_by_user, :status, :friend_ids, :follower_ids, :timeline, :lists_subscribed, :list_timeline

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

  private

  class TwitterError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super
    end
  end

  class RateLimitExceeded < TwitterError; end
  class Unauthorized < TwitterError; end
  class General < TwitterError; end
  class Unavailable < StandardError; end
  class InformTwitter < StandardError; end
  class NotFound < StandardError; end
end

faraday_middleware_files = Dir[File.join(File.dirname(__FILE__), "/faraday/**/*.rb")].sort
faraday_middleware_files.each do |file|
  require file
end

library_files = Dir[File.join(File.dirname(__FILE__), "/twitter/**/*.rb")].sort
library_files.each do |file|
  require file
end

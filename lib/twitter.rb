require 'forwardable'
require 'rubygems'

gem 'oauth', '~> 0.3.6'
require 'oauth'

gem 'hashie', '~> 0.1.3'
require 'hashie'

gem 'httparty', '~> 0.4.3'
require 'httparty'

module Twitter
  class TwitterError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super
    end
  end

  class RateLimitExceeded < TwitterError; end
  class Unauthorized      < TwitterError; end
  class General           < TwitterError; end

  class Unavailable   < StandardError; end
  class InformTwitter < StandardError; end
  class NotFound      < StandardError; end


  def self.firehose
    response = HTTParty.get('http://twitter.com/statuses/public_timeline.json', :format => :json)
    response.map { |tweet| Hashie::Mash.new(tweet) }
  end

  def self.user(id)
    response = HTTParty.get("http://twitter.com/users/show/#{id}.json", :format => :json)
    Hashie::Mash.new(response)
  end

  def self.status(id)
    response = HTTParty.get("http://twitter.com/statuses/show/#{id}.json", :format => :json)
    Hashie::Mash.new(response)
  end

  def self.friend_ids(id)
    HTTParty.get("http://twitter.com/friends/ids/#{id}.json", :format => :json)
  end

  def self.follower_ids(id)
    HTTParty.get("http://twitter.com/followers/ids/#{id}.json", :format => :json)
  end
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'twitter', 'oauth')
require File.join(directory, 'twitter', 'httpauth')
require File.join(directory, 'twitter', 'request')
require File.join(directory, 'twitter', 'base')
require File.join(directory, 'twitter', 'search')
require File.join(directory, 'twitter', 'trends')

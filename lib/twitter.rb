require "forwardable"
require "oauth"
require "hashie"
require "httparty"

module Twitter
  include HTTParty
  API_VERSION = 1
  base_uri "api.twitter.com/#{API_VERSION}"
  format :json

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
    response = get("/statuses/public_timeline.json")
    response.map { |tweet| Hashie::Mash.new(tweet) }
  end

  def self.user(id)
    response = get("/users/show/#{id}.json")
    Hashie::Mash.new(response)
  end

  def self.status(id)
    response = get("/statuses/show/#{id}.json")
    Hashie::Mash.new(response)
  end

  def self.friend_ids(id)
    get("/friends/ids/#{id}.json")
  end

  def self.follower_ids(id)
    get("/followers/ids/#{id}.json")
  end

  def self.timeline(id, options={})
    response = get("/statuses/user_timeline/#{id}.json", :query => options)
    response.map{|tweet| Hashie::Mash.new tweet}
  end

  # :per_page = max number of statues to get at once
  # :page = which page of tweets you wish to get
  def self.list_timeline(list_owner_username, slug, query = {})
    response = get("/#{list_owner_username}/lists/#{slug}/statuses.json", :query => query)
    response.map{|tweet| Hashie::Mash.new tweet}
  end
end

module Hashie
  class Mash

    # Converts all of the keys to strings, optionally formatting key name
    def rubyify_keys!
      keys.each{|k|
        v = delete(k)
        new_key = k.to_s.underscore
        self[new_key] = v
        v.rubyify_keys! if v.is_a?(Hash)
        v.each{|p| p.rubyify_keys! if p.is_a?(Hash)} if v.is_a?(Array)
      }
      self
    end

  end
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, "twitter", "oauth")
require File.join(directory, "twitter", "httpauth")
require File.join(directory, "twitter", "request")
require File.join(directory, "twitter", "base")
require File.join(directory, "twitter", "search")
require File.join(directory, "twitter", "trends")

require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'
require 'forwardable'
require 'hashie'
require 'oauth'

module Twitter

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
    @api_version ||= "1"
  end

  def self.api_version=(value)
    @api_version = value
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

  def self.raise_errors(response)
    case response.code.to_i
      when 400
        data = parse(response)
        raise RateLimitExceeded.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 401
        data = parse(response)
        raise Unauthorized.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 403
        data = parse(response)
        raise General.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
      when 404
        raise NotFound, "(#{response.code}): #{response.message}"
      when 500
        raise InformTwitter, "Twitter had an internal error. Please let them know in the group. (#{response.code}): #{response.message}"
      when 502..503
        raise Unavailable, "(#{response.code}): #{response.message}"
    end
  end

end

require File.expand_path("../faraday/raise_errors", __FILE__)
require File.expand_path("../twitter/oauth", __FILE__)
require File.expand_path("../twitter/request", __FILE__)
require File.expand_path("../twitter/base", __FILE__)
require File.expand_path("../twitter/search", __FILE__)
require File.expand_path("../twitter/trends", __FILE__)
require File.expand_path("../twitter/geo", __FILE__)
require File.expand_path("../twitter/unauthenticated", __FILE__)

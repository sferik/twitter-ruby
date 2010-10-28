require 'faraday'
require File.expand_path('../version', __FILE__)

module Twitter
  module Configuration
    VALID_OPTIONS_KEYS      = [:consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret, :adapter, :endpoint, :format, :proxy, :search_endpoint, :user_agent].freeze
    VALID_FORMATS           = [:json, :xml].freeze

    DEFAULT_ADAPTER         = Faraday.default_adapter.freeze
    DEFAULT_ENDPOINT        = 'https://api.twitter.com/1/'.freeze
    DEFAULT_SEARCH_ENDPOINT = 'https://search.twitter.com/'.freeze
    DEFAULT_FORMAT          = :json.freeze
    DEFAULT_PROXY           = nil.freeze
    DEFAULT_USER_AGENT      = "Twitter Ruby Gem #{Twitter::VERSION}".freeze

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}){|o,k| o.merge!(k => send(k)) }
    end

    def reset
      self.adapter         = DEFAULT_ADAPTER
      self.endpoint        = DEFAULT_ENDPOINT
      self.search_endpoint = DEFAULT_SEARCH_ENDPOINT
      self.format          = DEFAULT_FORMAT
      self.proxy           = DEFAULT_PROXY
      self.user_agent      = DEFAULT_USER_AGENT
    end
  end
end

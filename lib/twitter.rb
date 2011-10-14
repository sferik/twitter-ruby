require 'twitter/client'
require 'twitter/config'
require 'twitter/configuration'
require 'twitter/cursor'
require 'twitter/direct_message'
require 'twitter/language'
require 'twitter/list'
require 'twitter/metadata'
require 'twitter/photo'
require 'twitter/place'
require 'twitter/point'
require 'twitter/polygon'
require 'twitter/rate_limit_status'
require 'twitter/relationship'
require 'twitter/saved_search'
require 'twitter/search'
require 'twitter/settings'
require 'twitter/size'
require 'twitter/status'
require 'twitter/user'

module Twitter
  extend Config
  class << self
    # Alias for Twitter::Client.new
    #
    # @return [Twitter::Client]
    def new(options={})
      Twitter::Client.new(options)
    end

    # Delegate to Twitter::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end

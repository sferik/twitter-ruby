require 'twitter/client'
require 'twitter/config'

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

  # Delegate to Twitter::Client
  def self.respond_to?(method)
    return client.respond_to?(method) || super
  end
end

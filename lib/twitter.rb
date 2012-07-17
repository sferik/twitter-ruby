require 'twitter/client'
require 'twitter/configurable'

module Twitter
  class << self
    include Twitter::Configurable

    # Delegate to a Twitter::Client
    #
    # @return [Twitter::Client]
    def client
      if @client && @client.cache_key == options.hash
        @client
      else
        @client = Twitter::Client.new(options)
      end
    end

    def respond_to?(method, include_private=false)
      self.client.respond_to?(method, include_private) || super
    end

  private

    def method_missing(method, *args, &block)
      return super unless self.client.respond_to?(method)
      self.client.send(method, *args, &block)
    end

  end
end

Twitter.setup

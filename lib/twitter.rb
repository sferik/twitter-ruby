require 'twitter/client'
require 'twitter/configurable'
require 'twitter/default'

module Twitter
  class << self
    include Twitter::Configurable

    # Delegate to a Twitter::Client
    #
    # @return [Twitter::Client]
    def client
      Twitter::Client.new(options)
    end

    def respond_to?(method, include_private=false)
      self.client.respond_to?(method, include_private) || super
    end

    def reset!
      Twitter::Configurable.keys.each do |key|
        instance_variable_set("@#{key}", Twitter::Default.const_get(key.to_s.upcase.to_sym))
      end
      self
    end
    alias setup reset!

  private

    def method_missing(method, *args, &block)
      return super unless self.client.respond_to?(method)
      self.client.send(method, *args, &block)
    end

    def options
      @options = {}
      Twitter::Configurable.keys.each do |key|
        @options[key] = instance_variable_get("@#{key}")
      end
      @options
    end

  end
end

Twitter.setup

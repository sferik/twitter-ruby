require 'twitter/error'
require 'twitter/configuration'
require 'twitter/api'
require 'twitter/client'
require 'twitter/search'
require 'twitter/base'

module Twitter
  extend Configuration

  # Alias for Twitter::Client.new
  #
  # @return [Twitter::Client]
  def self.client(options={})
    Twitter::Client.new(options)
  end

  # Delegate to Twitter::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Twitter::Client
  def self.respond_to?(method)
    return client.respond_to?(method) || super
  end
end

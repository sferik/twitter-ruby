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

  def self.respond_to?(method, include_private = false)
    client.respond_to?(method, include_private) || super(method, include_private)
  end
end

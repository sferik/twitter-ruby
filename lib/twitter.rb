require 'twitter/configuration'
require 'twitter/client'
require 'twitter/error'

module Twitter
  extend Configuration

  def self.client(options={})
    Twitter::Client.new(options)
  end

  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end
end

require File.expand_path('../twitter/error', __FILE__)
require File.expand_path('../twitter/configuration', __FILE__)
require File.expand_path('../twitter/client', __FILE__)
require File.expand_path('../twitter/search', __FILE__)
require File.expand_path('../twitter/base', __FILE__)
require File.expand_path('../twitter/geo', __FILE__)

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

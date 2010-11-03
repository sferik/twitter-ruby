require File.expand_path('../twitter/error', __FILE__)
require File.expand_path('../twitter/configuration', __FILE__)
require File.expand_path('../twitter/api', __FILE__)
require File.expand_path('../twitter/client', __FILE__)
require File.expand_path('../twitter/search', __FILE__)
require File.expand_path('../twitter/base', __FILE__)

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
end

require 'twitter/version'
require 'twitter/error'
require 'twitter/client'
require 'twitter/configuration'

module Twitter
  def self.client(options={})
    Twitter::Client.new(options)
  end

  def self.method_missing(method, *args, &block)
    begin
      client.__send__(method, *args, &block)
    rescue NoMethodError
      super
    end
  end

  extend Configuration
end

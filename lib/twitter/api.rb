require 'twitter/authenticatable'
require 'twitter/configuration'
require 'twitter/connection'
require 'twitter/request'

module Twitter
  class API
    include Authenticatable
    include Connection
    include Request

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    # Creates a new API
    def initialize(options={})
      options = Twitter.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
  end
end

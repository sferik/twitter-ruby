require 'twitter/authenticatable'
require 'twitter/config'
require 'twitter/connection'
require 'twitter/request'

module Twitter
  class API
    include Authenticatable
    include Connection
    include Request

    attr_accessor *Config::VALID_OPTIONS_KEYS

    # Initializes a new API object
    #
    # @param attrs [Hash]
    # @return [Twitter::API]
    def initialize(attrs={})
      attrs = Twitter.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
    end

  end
end

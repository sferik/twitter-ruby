require File.expand_path('../connection', __FILE__)
require File.expand_path('../request', __FILE__)
require File.expand_path('../authentication', __FILE__)

module Twitter
  class API
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      options = Twitter.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Connection
    include Request
    include Authentication
  end
end

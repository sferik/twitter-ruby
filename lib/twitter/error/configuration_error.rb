require 'twitter/error'

module Twitter
  class Error
    class ConfigurationError < ::ArgumentError
    end
  end
end

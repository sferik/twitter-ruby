require 'twitter/version'
require 'faraday'

module Twitter
  module Configuration
    DEFAULT_ADAPTER = Faraday.default_adapter
    DEFAULT_ENDPOINT = 'https://api.twitter.com/1'
    DEFAULT_FORMAT = 'json'
    DEFAULT_USER_AGENT = "Twitter Ruby Gem #{Twitter::VERSION}"

    def configure
      yield self
    end

    def options
      @options ||= {
        :adapter => DEFAULT_ADAPTER,
        :endpoint => DEFAULT_ENDPOINT,
        :format => DEFAULT_FORMAT,
        :user_agent => DEFAULT_USER_AGENT
      }
    end

    def method_missing(symbol, *args)
      if (method = symbol.to_s).sub!(/\=$/, '')
        options[method.to_sym] = args.first
      else
        options.fetch(method.to_sym, super)
      end
    end
  end
end

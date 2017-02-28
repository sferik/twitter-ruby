require 'twitter/error'
require 'twitter/utils'
require 'twitter/version'

module Twitter
  class Client
    include Twitter::Utils
    attr_accessor :access_token, :access_token_secret, :consumer_key, :consumer_secret, :proxy, :timeouts
    attr_writer :user_agent

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Twitter::Client]
    def initialize(options = {})
      set_config_from_env
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    # @return [Boolean]
    def user_token?
      !(blank?(access_token) || blank?(access_token_secret))
    end

    # @return [String]
    def user_agent
      @user_agent ||= "TwitterRubyGem/#{Twitter::Version}"
    end

    # @return [Hash]
    def credentials
      {
        consumer_key: consumer_key,
        consumer_secret: consumer_secret,
        token: access_token,
        token_secret: access_token_secret,
      }
    end

    # @return [Boolean]
    def credentials?
      credentials.values.none? { |v| blank?(v) }
    end

  private

    def blank?(s)
      s.respond_to?(:empty?) ? s.empty? : !s
    end

    # Sets instance variables from environment variables
    def set_config_from_env
      env_keys.each do |key|
        instance_variable_set("@#{key}", ENV[key.upcase])
      end
    end

    # List of keys readable from environment variables
    def env_keys
      %w(consumer_key consumer_secret access_token access_token_secret)
    end
  end
end

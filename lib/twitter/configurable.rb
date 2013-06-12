require 'forwardable'
require 'twitter/default'
require 'twitter/error/configuration_error'

module Twitter
  module Configurable
    extend Forwardable
    attr_writer :consumer_secret, :oauth_token, :oauth_token_secret, :bearer_token
    attr_accessor :consumer_key, :endpoint, :connection_options, :identity_map, :middleware
    def_delegator :options, :hash

    class << self

      def keys
        @keys ||= [
          :consumer_key,
          :consumer_secret,
          :oauth_token,
          :oauth_token_secret,
          :bearer_token,
          :endpoint,
          :connection_options,
          :identity_map,
          :middleware,
        ]
      end

    end

    # Convenience method to allow configuration options to be set in a block
    #
    # @raise [Twitter::Error::ConfigurationError] Error is raised when supplied
    #   twitter credentials are not a String or Symbol.
    def configure
      yield self
      validate_credential_type!
      self
    end

    def reset!
      Twitter::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Twitter::Default.options[key])
      end
      self
    end
    alias setup reset!

    # @return [Boolean]
    def user_token?
      !!(@oauth_token && @oauth_token_secret)
    end

    # @return [Boolean]
    def bearer_token?
      !!@bearer_token
    end

    # @return [Boolean]
    def credentials?
      credentials.values.all? || bearer_token?
    end

  private

    # @return [Hash]
    def credentials
      {
        :consumer_key    => @consumer_key,
        :consumer_secret => @consumer_secret,
        :token           => @oauth_token,
        :token_secret    => @oauth_token_secret,
      }
    end

    # @return [Hash]
    def options
      Hash[Twitter::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    # Ensures that all credentials set during configuration are of a
    # valid type. Valid types are String and Symbol.
    #
    # @raise [Twitter::Error::ConfigurationError] Error is raised when
    #   supplied twitter credentials are not a String or Symbol.
    def validate_credential_type!
      credentials.each do |credential, value|
        next if value.nil?

        unless value.is_a?(String) || value.is_a?(Symbol)
          raise(Error::ConfigurationError, "Invalid #{credential} specified: #{value} must be a string or symbol.")
        end
      end
    end

  end
end

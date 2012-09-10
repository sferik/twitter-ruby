require 'twitter/default'

module Twitter
  module Configurable
    attr_writer :consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret
    attr_accessor :endpoint, :connection_options, :identity_map, :middleware

    class << self

      def keys
        @keys ||= [
          :consumer_key,
          :consumer_secret,
          :oauth_token,
          :oauth_token_secret,
          :endpoint,
          :connection_options,
          :identity_map,
          :middleware,
        ]
      end

    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

    # @return [Fixnum]
    def cache_key
      options.hash
    end

    def reset!
      Twitter::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Twitter::Default.options[key])
      end
      self
    end
    alias setup reset!

  private

    # @return [Hash]
    def credentials
      {
        :consumer_key => @consumer_key,
        :consumer_secret => @consumer_secret,
        :token => @oauth_token,
        :token_secret => @oauth_token_secret,
      }
    end

    # @return [Hash]
    def options
      Hash[Twitter::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

  end
end

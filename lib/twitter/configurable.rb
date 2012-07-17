require 'twitter/default'

module Twitter
  module Configurable

    AUTH_KEYS = [
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret,
    ] unless defined? AUTH_KEYS

    attr_writer *AUTH_KEYS

    CONFIG_KEYS = [
      :endpoint,
      :media_endpoint,
      :search_endpoint,
      :connection_options,
      :identity_map,
      :middleware,
    ] unless defined? CONFIG_KEYS

    attr_accessor *CONFIG_KEYS

    class << self

      def keys
        @keys ||= AUTH_KEYS + CONFIG_KEYS
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
        instance_variable_set("@#{key}", Twitter::Default.options[key])
      end
      self
    end
    alias setup reset!

  private

    # @return [Hash]
    # @note After Ruby 1.8 is deprecated, can be rewritten as:
    #   options.select{|key| AUTH_KEYS.include?(key)}
    def credentials
      Hash[options.select{|key, value| AUTH_KEYS.include?(key)}]
    end

    # @return [Hash]
    def options
      Hash[Twitter::Configurable.keys.map{|key| [key, instance_variable_get("@#{key}")]}]
    end

  end
end

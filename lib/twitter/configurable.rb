module Twitter
  module Configurable

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    CONFIG_KEYS = [
      :connection_options,
      :endpoint,
      :media_endpoint,
      :middleware,
    ] unless defined? CONFIG_KEYS

    attr_accessor *CONFIG_KEYS

    AUTH_KEYS = [
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret,
    ] unless defined? AUTH_KEYS

    attr_writer *AUTH_KEYS

    class << self

      def keys
        @keys ||= CONFIG_KEYS + AUTH_KEYS
      end

    end

  end
end

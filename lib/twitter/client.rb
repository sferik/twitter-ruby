require 'simple_oauth'
require 'twitter/version'
require 'uri'

module Twitter
  class Client
    attr_writer :access_token, :access_token_secret, :consumer_key,
      :consumer_secret, :user_agent
    alias oauth_token= access_token=
    alias oauth_token_secret= access_token_secret=

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Twitter::REST::Client]
    def initialize(options={})
      options.each do |key, value|
        send(:"#{key}=", value)
      end
      yield self if block_given?
      validate_credential_type!
    end

    # @return [String]
    def consumer_key
      if instance_variable_defined?(:@consumer_key)
        @consumer_key
      else
        ENV['TWITTER_CONSUMER_KEY']
      end
    end

    # @return [String]
    def consumer_secret
      if instance_variable_defined?(:@consumer_secret)
        @consumer_secret
      else
        ENV['TWITTER_CONSUMER_SECRET']
      end
    end

    # @return [String]
    def access_token
      if instance_variable_defined?(:@access_token)
        @access_token
      else
        ENV['TWITTER_ACCESS_TOKEN'] || ENV['TWITTER_OAUTH_TOKEN']
      end
    end
    alias oauth_token access_token

    # @return [String]
    def access_token_secret
      if instance_variable_defined?(:@access_token_secret)
        @access_token_secret
      else
        ENV['TWITTER_ACCESS_TOKEN_SECRET'] || ENV['TWITTER_OAUTH_TOKEN_SECRET']
      end
    end
    alias oauth_token_secret access_token_secret

    # @return [Boolean]
    def user_token?
      !!(access_token && access_token_secret)
    end

    def user_agent
      @user_agent ||= "Twitter Ruby Gem #{Twitter::Version}"
    end

    # @return [Hash]
    def credentials
      {
        :consumer_key    => consumer_key,
        :consumer_secret => consumer_secret,
        :token           => access_token,
        :token_secret    => access_token_secret,
      }
    end

    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

  private

    # Ensures that all credentials set during configuration are of a
    # valid type. Valid types are String and Symbol.
    #
    # @raise [Twitter::Error::ConfigurationError] Error is raised when
    #   supplied twitter credentials are not a String or Symbol.
    def validate_credential_type!
      credentials.each do |credential, value|
        next if value.nil?
        raise(Error::ConfigurationError, "Invalid #{credential} specified: #{value.inspect} must be a string or symbol.") unless value.is_a?(String) || value.is_a?(Symbol)
      end
    end

    def oauth_auth_header(method, uri, params={})
      uri = URI.parse(uri)
      SimpleOAuth::Header.new(method, uri, params, credentials)
    end

  end
end

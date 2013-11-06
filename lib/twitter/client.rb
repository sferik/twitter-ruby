require 'simple_oauth'
require 'twitter/version'
require 'uri'

module Twitter
  class Client
    attr_accessor :access_token, :access_token_secret, :consumer_key, :consumer_secret
    alias oauth_token access_token
    alias oauth_token= access_token=
    alias oauth_token_secret access_token_secret
    alias oauth_token_secret= access_token_secret=

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Twitter::Client]
    def initialize(options={})
      options.each do |key, value|
        send(:"#{key}=", value)
      end
      yield self if block_given?
      validate_credential_type!
    end

    # @return [Boolean]
    def user_token?
      !!(access_token && access_token_secret)
    end

    # @return [String]
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

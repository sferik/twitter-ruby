require 'twitter/action_factory'
require 'twitter/client'
require 'twitter/configurable'
require 'twitter/configuration'
require 'twitter/cursor'
require 'twitter/default'
require 'twitter/direct_message'
require 'twitter/entity'
require 'twitter/entity/hashtag'
require 'twitter/entity/symbol'
require 'twitter/entity/url'
require 'twitter/entity/user_mention'
require 'twitter/geo_factory'
require 'twitter/language'
require 'twitter/list'
require 'twitter/media_factory'
require 'twitter/metadata'
require 'twitter/oembed'
require 'twitter/place'
require 'twitter/profile_banner'
require 'twitter/rate_limit'
require 'twitter/relationship'
require 'twitter/saved_search'
require 'twitter/search_results'
require 'twitter/settings'
require 'twitter/size'
require 'twitter/source_user'
require 'twitter/suggestion'
require 'twitter/target_user'
require 'twitter/trend'
require 'twitter/tweet'
require 'twitter/user'

module Twitter
  class << self
    include Twitter::Configurable

    # Delegate to a Twitter::Client
    #
    # @return [Twitter::Client]
    def client
      @client = Twitter::Client.new(options) unless defined?(@client) && @client.hash == options.hash
      @client
    end

    # Has a client been initialized on the Twitter module
    #
    # @return [Boolean]
    def client?
      !!@client
    end

    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end
end

Twitter.setup

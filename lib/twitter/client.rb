require 'twitter/authenticatable'
require 'twitter/config'
require 'twitter/configuration'
require 'twitter/connection'
require 'twitter/cursor'
require 'twitter/direct_message'
require 'twitter/language'
require 'twitter/list'
require 'twitter/favorite'
require 'twitter/follow'
require 'twitter/mention'
require 'twitter/metadata'
require 'twitter/photo'
require 'twitter/place'
require 'twitter/point'
require 'twitter/polygon'
require 'twitter/rate_limit_status'
require 'twitter/relationship'
require 'twitter/reply'
require 'twitter/request'
require 'twitter/retweet'
require 'twitter/saved_search'
require 'twitter/settings'
require 'twitter/size'
require 'twitter/status'
require 'twitter/suggestion'
require 'twitter/trend'
require 'twitter/user'

module Twitter
  # Wrapper for the Twitter REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {http://dev.twitter.com/doc the Twitter API Documentation}.
  # @see http://dev.twitter.com/pages/every_developer
  class Client
    # Require client method modules after initializing the Client class in
    # order to avoid a superclass mismatch error, allowing those modules to be
    # Client-namespaced.
    require 'twitter/client/accounts'
    require 'twitter/client/activity'
    require 'twitter/client/block'
    require 'twitter/client/direct_messages'
    require 'twitter/client/favorites'
    require 'twitter/client/friends_and_followers'
    require 'twitter/client/help'
    require 'twitter/client/legal'
    require 'twitter/client/lists'
    require 'twitter/client/local_trends'
    require 'twitter/client/notification'
    require 'twitter/client/places_and_geo'
    require 'twitter/client/saved_searches'
    require 'twitter/client/search'
    require 'twitter/client/spam_reporting'
    require 'twitter/client/suggested_users'
    require 'twitter/client/timelines'
    require 'twitter/client/trends'
    require 'twitter/client/tweets'
    require 'twitter/client/urls'
    require 'twitter/client/users'

    include Twitter::Authenticatable
    include Twitter::Connection
    include Twitter::Request

    include Twitter::Client::Accounts
    include Twitter::Client::Activity
    include Twitter::Client::Block
    include Twitter::Client::DirectMessages
    include Twitter::Client::Favorites
    include Twitter::Client::FriendsAndFollowers
    include Twitter::Client::Help
    include Twitter::Client::Legal
    include Twitter::Client::Lists
    include Twitter::Client::LocalTrends
    include Twitter::Client::Notification
    include Twitter::Client::PlacesAndGeo
    include Twitter::Client::SavedSearches
    include Twitter::Client::Search
    include Twitter::Client::SpamReporting
    include Twitter::Client::SuggestedUsers
    include Twitter::Client::Timelines
    include Twitter::Client::Trends
    include Twitter::Client::Tweets
    include Twitter::Client::Urls
    include Twitter::Client::Users

    attr_accessor *Config::VALID_OPTIONS_KEYS

    # Initializes a new API object
    #
    # @param attrs [Hash]
    # @return [Twitter::Client]
    def initialize(attrs={})
      attrs = Twitter.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
    end

    # Returns the configured screen name or the screen name of the authenticated user
    #
    # @return [Twitter::User]
    def current_user
      @current_user ||= Twitter::User.new(self.verify_credentials)
    end

  end
end

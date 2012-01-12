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
require 'twitter/oembed'
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

    include Twitter::Authenticatable
    include Twitter::Connection
    include Twitter::Request

    require 'twitter/client/accounts'
    include Twitter::Client::Accounts

    require 'twitter/client/activity'
    include Twitter::Client::Activity

    require 'twitter/client/block'
    include Twitter::Client::Block

    require 'twitter/client/direct_messages'
    include Twitter::Client::DirectMessages

    require 'twitter/client/favorites'
    include Twitter::Client::Favorites

    require 'twitter/client/friends_and_followers'
    include Twitter::Client::FriendsAndFollowers

    require 'twitter/client/help'
    include Twitter::Client::Help

    require 'twitter/client/legal'
    include Twitter::Client::Legal

    require 'twitter/client/lists'
    include Twitter::Client::Lists

    require 'twitter/client/local_trends'
    include Twitter::Client::LocalTrends

    require 'twitter/client/notification'
    include Twitter::Client::Notification

    require 'twitter/client/places_and_geo'
    include Twitter::Client::PlacesAndGeo

    require 'twitter/client/saved_searches'
    include Twitter::Client::SavedSearches

    require 'twitter/client/search'
    include Twitter::Client::Search

    require 'twitter/client/spam_reporting'
    include Twitter::Client::SpamReporting

    require 'twitter/client/suggested_users'
    include Twitter::Client::SuggestedUsers

    require 'twitter/client/timelines'
    include Twitter::Client::Timelines

    require 'twitter/client/trends'
    include Twitter::Client::Trends

    require 'twitter/client/tweets'
    include Twitter::Client::Tweets

    require 'twitter/client/urls'
    include Twitter::Client::Urls

    require 'twitter/client/users'
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

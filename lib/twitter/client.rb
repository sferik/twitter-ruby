require 'twitter/api'
require 'twitter/configuration'
require 'twitter/cursor'
require 'twitter/direct_message'
require 'twitter/language'
require 'twitter/list'
require 'twitter/metadata'
require 'twitter/photo'
require 'twitter/place'
require 'twitter/point'
require 'twitter/polygon'
require 'twitter/rate_limit_status'
require 'twitter/relationship'
require 'twitter/saved_search'
require 'twitter/search'
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
  class Client < API

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

    alias :api_endpoint :endpoint

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

  end
end

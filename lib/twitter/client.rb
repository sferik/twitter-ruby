module Twitter
  # Wrapper for the Twitter REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {http://dev.twitter.com/doc the Twitter API Documentation}.
  # @see http://dev.twitter.com/pages/every_developer
  class Client < API
    # Require client method modules after initializing the Client class in
    # order to avoid a superclass mismatch error, allowing those modules to be
    # Client-namespaced.
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    alias :api_endpoint :endpoint

    include Twitter::Client::Utils

    include Twitter::Client::Account
    include Twitter::Client::Block
    include Twitter::Client::DirectMessages
    include Twitter::Client::Favorites
    include Twitter::Client::Friendship
    include Twitter::Client::FriendsAndFollowers
    include Twitter::Client::Geo
    include Twitter::Client::Legal
    include Twitter::Client::List
    include Twitter::Client::ListMembers
    include Twitter::Client::ListSubscribers
    include Twitter::Client::LocalTrends
    include Twitter::Client::Notification
    include Twitter::Client::SpamReporting
    include Twitter::Client::SavedSearches
    include Twitter::Client::Timeline
    include Twitter::Client::Trends
    include Twitter::Client::Tweets
    include Twitter::Client::User
  end
end

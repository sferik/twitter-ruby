module Twitter
  class Client < API
    # Require client method modules after initializing the Client class in
    # order to avoid a superclass mismatch error, allowing those modules to be
    # Client-namespaced.
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    alias :api_endpoint :endpoint

    include Utils

    include Timeline
    include Tweets
    include User
    include Trends
    include LocalTrends
    include List
    include ListMembers
    include ListSubscribers
    include DirectMessages
    include Friendship
    include FriendsAndFollowers
    include Account
    include Favorites
    include Notification
    include Block
    include SpamReporting
    include SavedSearches
    include Geo
    include Legal
  end
end

Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

module Twitter
  class Client
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      options = Twitter.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Connection
    include Request
    include Authentication
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

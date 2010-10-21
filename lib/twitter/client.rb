Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f }

module Twitter
  class Client
    attr_reader :access_key, :access_secret, :consumer_key, :consumer_secret
    attr_reader :adapter, :endpoint, :format, :user_agent

    def initialize(options={})
      options = Twitter.options.merge(options)

      @access_key      = options[:access_key]
      @access_secret   = options[:access_secret]
      @consumer_key    = options[:consumer_key]
      @consumer_secret = options[:consumer_secret]

      @adapter    = options[:adapter]
      @endpoint   = options[:endpoint]
      @format     = options[:format]
      @user_agent = options[:user_agent]
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
    include Help
  end
end

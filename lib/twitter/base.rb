module Twitter
  class Base
    extend Forwardable
    
    def_delegators :@client, :get, :post
    
    def initialize(oauth)
      @client = oauth.access_token
    end
    
    # Options: since_id, max_id, count, page, since
    def friends_timeline(query={})
      perform_get('/statuses/friends_timeline.json', :query => query)
    end
    
    # Options: id, user_id, screen_name, since_id, max_id, page, since
    def user_timeline(query={})
      perform_get('/statuses/user_timeline.json', :query => query)
    end
    
    # id Required. Id of the status to fetch.
    def status(id)
      perform_get("/statuses/show/#{id}.json")
    end
    
    # Options: in_reply_to_status_id
    def update(status, query={})
      perform_post("/statuses/update.json", :body => {:status => status}.merge(query))
    end
    
    # Options: since_id, max_id, since, page
    def replies(query={})
      perform_get('/statuses/replies.json', :query => query)
    end
    
    private
      def perform_get(path, options={})
        Twitter::Request.get(self, path, options)
      end
      
      def perform_post(path, options={})
        Twitter::Request.post(self, path, options)
      end
  end
end
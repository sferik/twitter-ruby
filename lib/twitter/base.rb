module Twitter
  class Base
    extend Forwardable

    def_delegators :client, :get, :post, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    # Options: since_id, max_id, count, page
    def home_timeline(query={})
      perform_get('/statuses/home_timeline.json', :query => query)
    end

    # Options: since_id, max_id, count, page, since
    def friends_timeline(query={})
      perform_get('/statuses/friends_timeline.json', :query => query)
    end

    # Options: id, user_id, screen_name, since_id, max_id, page, since, count
    def user_timeline(query={})
      perform_get('/statuses/user_timeline.json', :query => query)
    end

    def status(id)
      perform_get("/statuses/show/#{id}.json")
    end

    # Options: count
    def retweets(id, query={ })
      perform_get("/statuses/retweets/#{id}.json", :query => query)
    end

    # Options: in_reply_to_status_id
    def update(status, query={})
      perform_post("/statuses/update.json", :body => {:status => status}.merge(query))
    end

    # DEPRECATED: Use #mentions instead
    #
    # Options: since_id, max_id, since, page
    def replies(query={})
      warn("DEPRECATED: #replies is deprecated by Twitter; use #mentions instead")
      perform_get('/statuses/replies.json', :query => query)
    end

    # Options: since_id, max_id, count, page
    def mentions(query={})
      perform_get('/statuses/mentions.json', :query => query)
    end

    # Options: since_id, max_id, count, page
    def retweeted_by_me(query={})
      perform_get('/statuses/retweeted_by_me.json', :query => query)
    end

    # Options: since_id, max_id, count, page
    def retweeted_to_me(query={})
      perform_get('/statuses/retweeted_to_me.json', :query => query)
    end

    # Options: since_id, max_id, count, page
    def retweets_of_me(query={})
      perform_get('/statuses/retweets_of_me.json', :query => query)
    end

    def status_destroy(id)
      perform_post("/statuses/destroy/#{id}.json")
    end

    def retweet(id)
      perform_post("/statuses/retweet/#{id}.json")
    end

    # Options: id, user_id, screen_name, page
    def friends(query={})
      perform_get('/statuses/friends.json', :query => query)
    end

    # Options: id, user_id, screen_name, page
    def followers(query={})
      perform_get('/statuses/followers.json', :query => query)
    end

    def user(id, query={})
      perform_get("/users/show/#{id}.json", :query => query)
    end

    # Options: page, per_page
    def user_search(q, query={})
      q = URI.escape(q)
      perform_get("/users/search.json", :query => ({:q => q}.merge(query)))
    end

    # Options: since, since_id, page
    def direct_messages(query={})
      perform_get("/direct_messages.json", :query => query)
    end

    # Options: since, since_id, page
    def direct_messages_sent(query={})
      perform_get("/direct_messages/sent.json", :query => query)
    end

    def direct_message_create(user, text)
      perform_post("/direct_messages/new.json", :body => {:user => user, :text => text})
    end

    def direct_message_destroy(id)
      perform_post("/direct_messages/destroy/#{id}.json")
    end

    def friendship_create(id, follow=false)
      body = {}
      body.merge!(:follow => follow) if follow
      perform_post("/friendships/create/#{id}.json", :body => body)
    end

    def friendship_destroy(id)
      perform_post("/friendships/destroy/#{id}.json")
    end

    def friendship_exists?(a, b)
      perform_get("/friendships/exists.json", :query => {:user_a => a, :user_b => b})
    end

    def friendship_show(query)
      perform_get("/friendships/show.json", :query => query)
    end

    # Options: id, user_id, screen_name
    def friend_ids(query={})
      perform_get("/friends/ids.json", :query => query, :mash => false)
    end

    # Options: id, user_id, screen_name
    def follower_ids(query={})
      perform_get("/followers/ids.json", :query => query, :mash => false)
    end

    def verify_credentials
      perform_get("/account/verify_credentials.json")
    end

    # Device must be sms, im or none
    def update_delivery_device(device)
      perform_post('/account/update_delivery_device.json', :body => {:device => device})
    end

    # One or more of the following must be present:
    #   profile_background_color, profile_text_color, profile_link_color,
    #   profile_sidebar_fill_color, profile_sidebar_border_color
    def update_profile_colors(colors={})
      perform_post('/account/update_profile_colors.json', :body => colors)
    end
    
    # file should respond to #read and #path
    def update_profile_image(file)
      perform_post('/account/update_profile_image.json', build_multipart_bodies(:image => file))
    end

    # file should respond to #read and #path
    def update_profile_background(file, tile = false)
      perform_post('/account/update_profile_background_image.json', build_multipart_bodies(:image => file).merge(:tile => tile))
    end
    
    def rate_limit_status
      perform_get('/account/rate_limit_status.json')
    end

    # One or more of the following must be present:
    #   name, email, url, location, description
    def update_profile(body={})
      perform_post('/account/update_profile.json', :body => body)
    end

    # Options: id, page
    def favorites(query={})
      perform_get('/favorites.json', :query => query)
    end

    def favorite_create(id)
      perform_post("/favorites/create/#{id}.json")
    end

    def favorite_destroy(id)
      perform_post("/favorites/destroy/#{id}.json")
    end

    def enable_notifications(id)
      perform_post("/notifications/follow/#{id}.json")
    end

    def disable_notifications(id)
      perform_post("/notifications/leave/#{id}.json")
    end

    def block(id)
      perform_post("/blocks/create/#{id}.json")
    end

    def unblock(id)
      perform_post("/blocks/destroy/#{id}.json")
    end

    def help
      perform_get('/help/test.json')
    end

    def list_create(list_owner_username, options)
      perform_post("/#{list_owner_username}/lists.json", :body => {:user => list_owner_username}.merge(options))
    end

    def list_update(list_owner_username, slug, options)
      perform_put("/#{list_owner_username}/lists/#{slug}.json", :body => options)
    end

    def list_delete(list_owner_username, slug)
      perform_delete("/#{list_owner_username}/lists/#{slug}.json")
    end

    def lists(list_owner_username=nil)
      path = "/#{list_owner_username}" if list_owner_username
      path += "/lists.json"
      perform_get(path)
    end

    def list(list_owner_username, slug)
      perform_get("/#{list_owner_username}/lists/#{slug}.json")
    end

    # :per_page = max number of statues to get at once
    # :page = which page of tweets you wish to get
    def list_timeline(list_owner_username, slug, query = {})
      perform_get("/#{list_owner_username}/lists/#{slug}/statuses.json", :query => query)
    end

    def memberships(list_owner_username, query={})
      perform_get("/#{list_owner_username}/lists/memberships.json", :query => query)
    end

    def list_members(list_owner_username, slug, cursor = nil)
      path = "/#{list_owner_username}/#{slug}/members.json"
      path += "?cursor=#{cursor}" if cursor
      perform_get(path)
    end

    def list_add_member(list_owner_username, slug, new_id)
      perform_post("/#{list_owner_username}/#{slug}/members.json", :body => {:id => new_id})
    end

    def list_remove_member(list_owner_username, slug, id)
      perform_delete("/#{list_owner_username}/#{slug}/members.json", :query => {:id => id})
    end

    def is_list_member?(list_owner_username, slug, id)
      perform_get("/#{list_owner_username}/#{slug}/members/#{id}.json").error.nil?
    end

    def list_subscribers(list_owner_username, slug)
      perform_get("/#{list_owner_username}/#{slug}/subscribers.json")
    end

    def list_subscribe(list_owner_username, slug)
      perform_post("/#{list_owner_username}/#{slug}/subscribers.json")
    end

    def list_unsubscribe(list_owner_username, slug)
      perform_delete("/#{list_owner_username}/#{slug}/subscribers.json")
    end

    def list_subscriptions(list_owner_username)
      perform_get("/#{list_owner_username}/lists/subscriptions.json")
    end

    
    def blocked_ids
      perform_get("/blocks/blocking/ids.json", :mash => false)
    end
    
    def blocking(options={})
      perform_get("/blocks/blocking.json", options)
    end
    
    
  protected
    def self.mime_type(file)
      case 
        when file =~ /\.jpg/ then 'image/jpg'
        when file =~ /\.gif$/ then 'image/gif'
        when file =~ /\.png$/ then 'image/png'
        else 'application/octet-stream'
      end
    end
    def mime_type(f) self.class.mime_type(f) end
  
    CRLF = "\r\n"
    def self.build_multipart_bodies(parts)
      boundary = Time.now.to_i.to_s(16)
      body = ""
      parts.each do |key, value|
        esc_key = CGI.escape(key.to_s)
        body << "--#{boundary}#{CRLF}"
        if value.respond_to?(:read)
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"; filename=\"#{File.basename(value.path)}\"#{CRLF}"
          body << "Content-Type: #{mime_type(value.path)}#{CRLF*2}"
          body << value.read
        else
          body << "Content-Disposition: form-data; name=\"#{esc_key}\"#{CRLF*2}#{value}"
        end
        body << CRLF
      end
      body << "--#{boundary}--#{CRLF*2}"
      {
        :body => body,
        :headers => {"Content-Type" => "multipart/form-data; boundary=#{boundary}"}
      }
    end
    def build_multipart_bodies(parts) self.class.build_multipart_bodies(parts) end

    private
      def perform_get(path, options={})
        Twitter::Request.get(self, path, options)
      end

      def perform_post(path, options={})
        Twitter::Request.post(self, path, options)
      end

      def perform_put(path, options={})
        Twitter::Request.put(self, path, options)
      end

      def perform_delete(path, options={})
        Twitter::Request.delete(self, path, options)
      end
  end
end

module Twitter
  class Base
    extend Forwardable

    def_delegators :client, :get, :post, :put, :delete

    attr_reader :client

    def initialize(client)
      @client = client
    end

    # Options: since_id, max_id, count, page
    def home_timeline(options={})
      perform_get("statuses/home_timeline.json", options)
    end

    # Options: since_id, max_id, count, page, since
    def friends_timeline(options={})
      perform_get("statuses/friends_timeline.json", options)
    end

    # Options: id, user_id, screen_name, since_id, max_id, page, since, count
    def user_timeline(options={})
      perform_get("statuses/user_timeline.json", options)
    end

    def status(id)
      perform_get("statuses/show/#{id}.json")
    end

    # Options: count
    def retweets(id, options={})
      perform_get("statuses/retweets/#{id}.json", options)
    end

    # Options: in_reply_to_status_id
    def update(status, options={})
      perform_post("statuses/update.json", :body => {:status => status}.merge(options))
    end

    # DEPRECATED: Use #mentions instead
    #
    # Options: since_id, max_id, since, page
    def replies(options={})
      warn("DEPRECATED: #replies is deprecated by Twitter; use #mentions instead")
      perform_get("statuses/replies.json", options)
    end

    # Options: since_id, max_id, count, page
    def mentions(options={})
      perform_get("statuses/mentions.json", options)
    end

    # Options: since_id, max_id, count, page
    def retweeted_by_me(options={})
      perform_get("statuses/retweeted_by_me.json", options)
    end

    # Options: since_id, max_id, count, page
    def retweeted_to_me(options={})
      perform_get("statuses/retweeted_to_me.json", options)
    end

    # Options: since_id, max_id, count, page
    def retweets_of_me(options={})
      perform_get("statuses/retweets_of_me.json", options)
    end

    # options: count, page, ids_only
    def retweeters_of(id, options={})
      ids_only = !!(options.delete(:ids_only))
      perform_get("statuses/#{id}/retweeted_by#{"/ids" if ids_only}.json", options)
    end

    def status_destroy(id)
      perform_post("statuses/destroy/#{id}.json")
    end

    def retweet(id)
      perform_post("statuses/retweet/#{id}.json", :body => {})
    end

    # Options: id, user_id, screen_name, page
    def friends(options={})
      perform_get("statuses/friends.json", options)
    end

    # Options: id, user_id, screen_name, page
    def followers(options={})
      perform_get("statuses/followers.json", options)
    end

    def user(id_or_screen_name, options={})
      if id_or_screen_name.is_a?(Integer)
        options.merge!({:user_id => id_or_screen_name})
      elsif id_or_screen_name.is_a?(String)
        options.merge!({:screen_name => id_or_screen_name})
      end
      perform_get("users/show.json", options)
    end

    def users(*ids_or_screen_names)
      ids, screen_names = [], []
      ids_or_screen_names.flatten.each do |id_or_screen_name|
        if id_or_screen_name.is_a?(Integer)
          ids << id_or_screen_name
        elsif id_or_screen_name.is_a?(String)
          screen_names << id_or_screen_name
        end
      end
      options = {}
      options[:user_id] = ids.join(",") unless ids.empty?
      options[:screen_name] = screen_names.join(",") unless screen_names.empty?
      perform_get("users/lookup.json", options)
    end

    # Options: page, per_page
    def user_search(query, options={})
      perform_get("users/search.json", {:q => query}.merge(options))
    end

    # Options: since, since_id, page
    def direct_messages(options={})
      perform_get("direct_messages.json", options)
    end

    # Options: since, since_id, page
    def direct_messages_sent(options={})
      perform_get("direct_messages/sent.json", options)
    end

    def direct_message_create(user_id_or_screen_name, text)
      perform_post("direct_messages/new.json", :body => {:user => user_id_or_screen_name, :text => text})
    end

    def direct_message_destroy(id)
      perform_post("direct_messages/destroy/#{id}.json")
    end

    def friendship_create(id, follow=false)
      body = {}
      body.merge!(:follow => follow) if follow
      perform_post("friendships/create/#{id}.json", :body => body)
    end

    def friendship_destroy(id)
      perform_post("friendships/destroy/#{id}.json")
    end

    def friendship_exists?(user_id_or_screen_name_a, user_id_or_screen_name_b)
      perform_get("friendships/exists.json", {:user_a => user_id_or_screen_name_a, :user_b => user_id_or_screen_name_b})
    end

    def friendship_show(options)
      perform_get("friendships/show.json", options)
    end

    # Options: id, user_id, screen_name
    def friend_ids(options={})
      perform_get("friends/ids.json", options)
    end

    # Options: id, user_id, screen_name
    def follower_ids(options={})
      perform_get("followers/ids.json", options)
    end

    def verify_credentials
      perform_get("account/verify_credentials.json")
    end

    # Device must be sms, im or none
    def update_delivery_device(device)
      perform_post("account/update_delivery_device.json", :body => {:device => device})
    end

    # One or more of the following must be present:
    #   profile_background_color, profile_text_color, profile_link_color,
    #   profile_sidebar_fill_color, profile_sidebar_border_color
    def update_profile_colors(colors={})
      perform_post("account/update_profile_colors.json", :body => colors)
    end

    # file should respond to #read and #path
    def update_profile_image(file)
      perform_post("account/update_profile_image.json", build_multipart_bodies(:image => file))
    end

    # file should respond to #read and #path
    def update_profile_background(file, tile = false)
      perform_post("account/update_profile_background_image.json", build_multipart_bodies(:image => file).merge(:tile => tile))
    end

    def rate_limit_status
      perform_get("account/rate_limit_status.json")
    end

    # One or more of the following must be present:
    #   name, email, url, location, description
    def update_profile(body={})
      perform_post("account/update_profile.json", :body => body)
    end

    # Options: id, page
    def favorites(options={})
      perform_get("favorites.json", options)
    end

    def favorite_create(id)
      perform_post("favorites/create/#{id}.json")
    end

    def favorite_destroy(id)
      perform_post("favorites/destroy/#{id}.json")
    end

    def enable_notifications(id)
      perform_post("notifications/follow/#{id}.json")
    end

    def disable_notifications(id)
      perform_post("notifications/leave/#{id}.json")
    end

    def block(id)
      perform_post("blocks/create/#{id}.json")
    end

    def unblock(id)
      perform_post("blocks/destroy/#{id}.json")
    end

    # When reporting a user for spam, specify one or more of id, screen_name, or user_id
    def report_spam(options)
      perform_post("report_spam.json", :body => options)
    end

    def help
      perform_get("help/test.json")
    end

    def list_create(list_owner_screen_name, options)
      perform_post("#{list_owner_screen_name}/lists.json", :body => {:user => list_owner_screen_name}.merge(options))
    end

    def list_update(list_owner_screen_name, slug, options)
      perform_put("#{list_owner_screen_name}/lists/#{slug}.json", :body => options)
    end

    def list_delete(list_owner_screen_name, slug)
      perform_delete("#{list_owner_screen_name}/lists/#{slug}.json")
    end

    def lists(list_owner_screen_name = nil, options={})
      path = case list_owner_screen_name
      when nil
        "lists.json"
      when Hash
        options = list_owner_screen_name
        "lists.json"
      else
        "#{list_owner_screen_name}/lists.json"
      end
      perform_get(path, options)
    end

    def list(list_owner_screen_name, slug)
      perform_get("#{list_owner_screen_name}/lists/#{slug}.json")
    end

    # :per_page = max number of statues to get at once
    # :page = which page of tweets you wish to get
    def list_timeline(list_owner_screen_name, slug, options = {})
      perform_get("#{list_owner_screen_name}/lists/#{slug}/statuses.json", options)
    end

    def memberships(list_owner_screen_name, options={})
      perform_get("#{list_owner_screen_name}/lists/memberships.json", options)
    end

    def subscriptions(list_owner_screen_name, options = {})
      perform_get("#{list_owner_screen_name}/lists/subscriptions.json", options)
    end

    def list_members(list_owner_screen_name, slug, options = {})
      perform_get("#{list_owner_screen_name}/#{slug}/members.json", options)
    end

    def list_add_member(list_owner_screen_name, slug, new_id)
      perform_post("#{list_owner_screen_name}/#{slug}/members.json", :body => {:id => new_id})
    end

    def list_remove_member(list_owner_screen_name, slug, id)
      perform_delete("#{list_owner_screen_name}/#{slug}/members.json", {:id => id})
    end

    def is_list_member?(list_owner_screen_name, slug, id)
      perform_get("#{list_owner_screen_name}/#{slug}/members/#{id}.json").error.nil?
    end

    def list_subscribers(list_owner_screen_name, slug, options={})
      perform_get("#{list_owner_screen_name}/#{slug}/subscribers.json", options)
    end

    def list_subscribe(list_owner_screen_name, slug)
      perform_post("#{list_owner_screen_name}/#{slug}/subscribers.json", :body => {})
    end

    def list_unsubscribe(list_owner_screen_name, slug)
      perform_delete("#{list_owner_screen_name}/#{slug}/subscribers.json")
    end

    def blocked_ids
      perform_get("blocks/blocking/ids.json")
    end

    def blocking(options={})
      perform_get("blocks/blocking.json", options)
    end

    def saved_searches
      perform_get("saved_searches.json")
    end

    def saved_search(id)
      perform_get("saved_searches/show/#{id}.json")
    end

    def saved_search_create(options)
      perform_post("saved_searches/create.json", :body => {:options => options})
    end

    def saved_search_destroy(id)
      perform_delete("saved_searches/destroy/#{id}.json")
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

    def connection
      headers = {
        :user_agent => Twitter.user_agent
      }
      @connection ||= Faraday::Connection.new(:url => Twitter.api_endpoint, :headers => headers) do |builder|
        builder.adapter(@adapter || Faraday.default_adapter)
        builder.use Faraday::Response::RaiseErrors
        builder.use Faraday::Response::MultiJson
        builder.use Faraday::Response::Mashify
      end
    end

    def perform_get(path, options={})
      results = connection.get do |request|
        request.url path, options
      end.body
    end

    def perform_post(path, options={})
      results = connection.post do |request|
        request.path = path
        request.body = options[:body]
      end.body
    end

    def perform_put(path, options={})
      results = connection.put do |request|
        request.path = path
        request.body = options[:body]
      end.body
    end

    def perform_delete(path, options={})
      results = connection.delete do |request|
        request.url path, options
      end.body
    end

  end
end

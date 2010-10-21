module Twitter
  class Authenticated
    extend ConfigHelper
    include ConnectionHelper
    include RequestHelper
    attr_reader :access_key, :access_secret, :consumer_key, :consumer_secret

    def initialize(options={})
      @consumer_key = options[:consumer_key] || Twitter.consumer_key
      @consumer_secret = options[:consumer_secret] || Twitter.consumer_secret
      @access_key = options[:access_key] || Twitter.access_key
      @access_secret = options[:access_secret] || Twitter.access_secret
      @adapter = options[:adapter] || Twitter.adapter
      @api_endpoint = options[:api_endpoint] || Twitter.api_endpoint
      @api_version = options[:api_version] || Twitter.api_version
      @format = options[:format] || Twitter.format
      @protocol = options[:protocol] || Twitter.protocol
      @user_agent = options[:user_agent] || Twitter.user_agent
    end

    def public_timeline(options={})
      perform_get("statuses/public_timeline.#{self.class.format}", options)
    end

    # Options: since_id, max_id, count, page
    def home_timeline(options={})
      perform_get("statuses/home_timeline.#{self.class.format}", options)
    end

    # Options: since_id, max_id, count, page, since
    def friends_timeline(options={})
      perform_get("statuses/friends_timeline.#{self.class.format}", options)
    end

    # Options: id, user_id, screen_name, since_id, max_id, page, since, count
    def user_timeline(options={})
      perform_get("statuses/user_timeline.#{self.class.format}", options)
    end

    def retweeted_to_user(user_id_or_screen_name, options={})
      case user_id_or_screen_name
      when Fixnum
        options.merge!({:user_id => user_id_or_screen_name})
      when String
        options.merge!({:screen_name => user_id_or_screen_name})
      end
      perform_get("statuses/retweeted_to_user.#{self.class.format}", options)
    end

    def retweeted_by_user(user_id_or_screen_name, options={})
      case user_id_or_screen_name
      when Fixnum
        options.merge!({:user_id => user_id_or_screen_name})
      when String
        options.merge!({:screen_name => user_id_or_screen_name})
      end
      perform_get("statuses/retweeted_by_user.#{self.class.format}", options)
    end

    def status(id, options={})
      perform_get("statuses/show/#{id}.#{self.class.format}", options)
    end

    # Options: in_reply_to_status_id
    def update(status, options={})
      perform_post("statuses/update.#{self.class.format}", {:status => status}.merge(options))
    end

    # Options: trim_user, include_entities
    def status_destroy(id, options={})
      perform_delete("statuses/destroy/#{id}.#{self.class.format}", options)
    end

    # Options: trim_user, include_entities
    def retweet(id, options={})
      perform_post("statuses/retweet/#{id}.#{self.class.format}", options)
    end

    # Options: count
    def retweets(id, options={})
      perform_get("statuses/retweets/#{id}.#{self.class.format}", options)
    end

    # Options: since_id, max_id, count, page
    def mentions(options={})
      perform_get("statuses/mentions.#{self.class.format}", options)
    end

    # Options: since_id, max_id, count, page
    def retweeted_by_me(options={})
      perform_get("statuses/retweeted_by_me.#{self.class.format}", options)
    end

    # Options: since_id, max_id, count, page
    def retweeted_to_me(options={})
      perform_get("statuses/retweeted_to_me.#{self.class.format}", options)
    end

    # Options: since_id, max_id, count, page
    def retweets_of_me(options={})
      perform_get("statuses/retweets_of_me.#{self.class.format}", options)
    end

    # options: count, page, ids_only
    def retweeters_of(id, options={})
      ids_only = !!(options.delete(:ids_only))
      perform_get("statuses/#{id}/retweeted_by#{"/ids" if ids_only}.#{self.class.format}", options)
    end

    # Options: id, user_id, screen_name, page
    def friends(options={})
      perform_get("statuses/friends.#{self.class.format}", options)
    end

    # Options: id, user_id, screen_name, page
    def followers(options={})
      perform_get("statuses/followers.#{self.class.format}", options)
    end

    def user(user_id_or_screen_name, options={})
      case user_id_or_screen_name
      when Fixnum
        options.merge!({:user_id => user_id_or_screen_name})
      when String
        options.merge!({:screen_name => user_id_or_screen_name})
      end
      perform_get("users/show.#{self.class.format}", options)
    end

    def profile_image(screen_name, options={})
      connection_with_unparsed_response.get do |request|
        request.url("users/profile_image/#{screen_name}.#{self.class.format}", options)
      end.headers["location"]
    end

    def users(user_ids_or_screen_names, options={})
      merge_users_into_options!(Array(user_ids_or_screen_names), options)
      perform_get("users/lookup.#{self.class.format}", options)
    end

    # Options: page, per_page
    def user_search(query, options={})
      perform_get("users/search.#{self.class.format}", {:q => query}.merge(options))
    end

    def direct_message(id, options={})
      perform_get("direct_messages/show/#{id}.#{self.class.format}", options)
    end

    # Options: since, since_id, page
    def direct_messages(options={})
      perform_get("direct_messages.#{self.class.format}", options)
    end

    # Options: since, since_id, page
    def direct_messages_sent(options={})
      perform_get("direct_messages/sent.#{self.class.format}", options)
    end

    def direct_message_create(user_id_or_screen_name, text, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      options[:text] = text
      perform_post("direct_messages/new.#{self.class.format}", options)
    end

    def direct_message_destroy(id, options={})
      perform_delete("direct_messages/destroy/#{id}.#{self.class.format}", options)
    end

    def friendship(options={})
      perform_get("friendships/show.#{self.class.format}", options)
    end
    alias :friendship_show :friendship

    def friendships(user_ids_or_screen_names, options={})
      merge_users_into_options!(Array(user_ids_or_screen_names), options)
      perform_get("friendships/lookup.#{self.class.format}", options)
    end

    def friendship_create(user_id_or_screen_name, follow=false, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      options[:follow] = follow if follow
      perform_post("friendships/create.#{self.class.format}", options)
    end

    def friendship_update(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_post("friendships/update.#{self.class.format}", options)
    end

    def friendship_destroy(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_delete("friendships/destroy.#{self.class.format}", options)
    end

    def friendship_exists?(user_id_or_screen_name_a, user_id_or_screen_name_b)
      response = perform_get("friendships/exists.#{self.class.format}", {:user_a => user_id_or_screen_name_a, :user_b => user_id_or_screen_name_b})
      case self.class.format.to_s
      when 'xml'
        !%w(0 false).include?(response.friends)
      else
        response
      end
    end

    # Options: id, user_id, screen_name
    def friend_ids(options={})
      perform_get("friends/ids.#{self.class.format}", options)
    end

    # Options: id, user_id, screen_name
    def follower_ids(options={})
      perform_get("followers/ids.#{self.class.format}", options)
    end

    def verify_credentials(options={})
      perform_get("account/verify_credentials.#{self.class.format}", options)
    end

    # Device must be sms, im or none
    def update_delivery_device(device, options={})
      options[:device] = device
      perform_post("account/update_delivery_device.#{self.class.format}", options)
    end

    # One or more of the following must be present:
    #   profile_background_color, profile_text_color, profile_link_color,
    #   profile_sidebar_fill_color, profile_sidebar_border_color
    def update_profile_colors(options={})
      perform_post("account/update_profile_colors.#{self.class.format}", options)
    end

    # file should respond to #read and #path
    def update_profile_image(file)
      perform_post("account/update_profile_image.#{self.class.format}", :image => file)
    end

    # file should respond to #read and #path
    def update_profile_background(file, tile = false)
      perform_post("account/update_profile_background_image.#{self.class.format}", :image => file, :tile => tile)
    end

    # One or more of the following must be present:
    #   name, email, url, location, description
    def update_profile(options={})
      perform_post("account/update_profile.#{self.class.format}", options)
    end

    def totals(options={})
      perform_get("account/totals.#{self.class.format}", options)
    end

    def settings(options={})
      perform_get("account/settings.#{self.class.format}", options)
    end

    # Options: id, page
    def favorites(options={})
      perform_get("favorites.#{self.class.format}", options)
    end

    def favorite_create(id, options={})
      perform_post("favorites/create/#{id}.#{self.class.format}", options)
    end

    def favorite_destroy(id, options={})
      perform_delete("favorites/destroy/#{id}.#{self.class.format}", options)
    end

    def enable_notifications(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_post("notifications/follow.#{self.class.format}", options)
    end

    def disable_notifications(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_post("notifications/leave.#{self.class.format}", options)
    end

    def block(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_post("blocks/create.#{self.class.format}", options)
    end

    def unblock(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_delete("blocks/destroy.#{self.class.format}", options)
    end

    def report_spam(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_post("report_spam.#{self.class.format}", options)
    end

    def list_create(list_owner_screen_name, name, options={})
      options[:name] = name
      perform_post("#{list_owner_screen_name}/lists.#{self.class.format}", options)
    end

    def list_update(list_owner_screen_name, slug, options={})
      perform_put("#{list_owner_screen_name}/lists/#{slug}.#{self.class.format}", options)
    end

    def list_delete(list_owner_screen_name, slug, options={})
      perform_delete("#{list_owner_screen_name}/lists/#{slug}.#{self.class.format}", options)
    end

    def list(list_owner_screen_name, slug, options={})
      perform_get("#{list_owner_screen_name}/lists/#{slug}.#{self.class.format}", options)
    end

    def lists_subscribed(options={})
      perform_get("lists/all.#{self.class.format}", options)
    end

    def lists(list_owner_screen_name=nil, options={})
      path = case list_owner_screen_name
      when nil
        "lists.#{self.class.format}"
      when Hash
        options = list_owner_screen_name
        "lists.#{self.class.format}"
      else
        "#{list_owner_screen_name}/lists.#{self.class.format}"
      end
      perform_get(path, options)
    end

    def suggestions(category_slug=nil, options={})
      path = case category_slug
      when nil
        "users/suggestions.#{self.class.format}"
      when Hash
        options = category_slug
        "users/suggestions.#{self.class.format}"
      else
        "users/suggestions/#{category_slug}.#{self.class.format}"
      end
      perform_get(path, options)
    end

    # :per_page = max number of statues to get at once
    # :page = which page of tweets you wish to get
    def list_timeline(list_owner_screen_name, slug, options={})
      perform_get("#{list_owner_screen_name}/lists/#{slug}/statuses.#{self.class.format}", options)
    end

    def memberships(list_owner_screen_name, options={})
      perform_get("#{list_owner_screen_name}/lists/memberships.#{self.class.format}", options)
    end

    def subscriptions(list_owner_screen_name, options={})
      perform_get("#{list_owner_screen_name}/lists/subscriptions.#{self.class.format}", options)
    end

    def list_members(list_owner_screen_name, slug, options={})
      perform_get("#{list_owner_screen_name}/#{slug}/members.#{self.class.format}", options)
    end

    def list_add_member(list_owner_screen_name, slug, new_id, options={})
      options[:id] = new_id
      perform_post("#{list_owner_screen_name}/#{slug}/members.#{self.class.format}", options)
    end

    def list_remove_member(list_owner_screen_name, slug, id, options={})
      options[:id] = id
      perform_delete("#{list_owner_screen_name}/#{slug}/members.#{self.class.format}", options)
    end

    def is_list_member?(list_owner_screen_name, slug, id, options={})
      begin
        perform_get("#{list_owner_screen_name}/#{slug}/members/#{id}.#{self.class.format}", options)
        true
      rescue Twitter::NotFound
        false
      end
    end

    def list_subscribers(list_owner_screen_name, slug, options={})
      perform_get("#{list_owner_screen_name}/#{slug}/subscribers.#{self.class.format}", options)
    end

    def list_subscribe(list_owner_screen_name, slug, options={})
      perform_post("#{list_owner_screen_name}/#{slug}/subscribers.#{self.class.format}", options)
    end

    def list_unsubscribe(list_owner_screen_name, slug, options={})
      perform_delete("#{list_owner_screen_name}/#{slug}/subscribers.#{self.class.format}", options)
    end

    def blocked_ids(options={})
      perform_get("blocks/blocking/ids.#{self.class.format}", options)
    end

    def blocking(options={})
      perform_get("blocks/blocking.#{self.class.format}", options)
    end

    def saved_searches(options={})
      perform_get("saved_searches.#{self.class.format}", options)
    end

    def saved_search(id, options={})
      perform_get("saved_searches/show/#{id}.#{self.class.format}", options)
    end

    def saved_search_create(query)
      options = query.is_a?(Hash) ? query : {:query => query}
      perform_post("saved_searches/create.#{self.class.format}", options)
    end

    def saved_search_destroy(id, options={})
      perform_delete("saved_searches/destroy/#{id}.#{self.class.format}", options)
    end

    def related_results(id, options={})
      perform_get("related_results/show/#{id}.#{self.class.format}", options)
    end

    def rate_limit_status(options={})
      perform_get("account/rate_limit_status.#{self.class.format}", options)
    end

    def friendships_outgoing(options={})
      perform_get("friendships/outgoing.#{self.class.format}", options)
    end

    def friendships_incoming(options={})
      perform_get("friendships/incoming.#{self.class.format}", options)
    end

    def list_add_members(list_owner_screen_name, slug, new_ids, options={})
      merge_users_into_options!(Array(new_ids), options)
      perform_post("#{list_owner_screen_name}/#{slug}/create_all.#{self.class.format}", options)
    end

    def is_subscriber?(list_owner_screen_name, slug, id, options={})
      begin
        perform_get("#{list_owner_screen_name}/#{slug}/subscribers/#{id}.#{self.class.format}", options)
        true
      rescue Twitter::NotFound
        false
      end
    end

    def block_exists?(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      begin
        perform_get("blocks/exists.#{self.class.format}", options)
        true
      rescue Twitter::NotFound
        false
      end
    end

    private

    def merge_user_into_options!(user_id_or_screen_name, options={})
      case user_id_or_screen_name
      when Fixnum
        options[:user_id] = user_id_or_screen_name
      when String
        options[:screen_name] = user_id_or_screen_name
      end
      options
    end

    def merge_users_into_options!(user_ids_or_screen_names, options={})
      user_ids, screen_names = [], []
      user_ids_or_screen_names.flatten.each do |user_id_or_screen_name|
        case user_id_or_screen_name
        when Fixnum
          user_ids << user_id_or_screen_name
        when String
          screen_names << user_id_or_screen_name
        end
      end
      options[:user_id] = user_ids.join(",") unless user_ids.empty?
      options[:screen_name] = screen_names.join(",") unless screen_names.empty?
    end

  end
end

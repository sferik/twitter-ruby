module Twitter
  class Unauthenticated
    extend ConfigHelper
    include ConnectionHelper
    include RequestHelper

    def initialize(options={})
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

    def user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("users/show.#{self.class.format}", options)
    end

    def profile_image(screen_name, options={})
      connection_with_unparsed_response.get do |request|
        request.url("users/profile_image/#{screen_name}.#{self.class.format}", options)
      end.headers["location"]
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

    def retweeted_to_user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/retweeted_to_user.#{self.class.format}", options)
    end

    def retweeted_by_user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/retweeted_by_user.#{self.class.format}", options)
    end

    def status(id, options={})
      perform_get("statuses/show/#{id}.#{self.class.format}", options)
    end

    def friend_ids(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("friends/ids.#{self.class.format}", options)
    end

    def follower_ids(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("followers/ids.#{self.class.format}", options)
    end

    def timeline(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/user_timeline.#{self.class.format}", options)
    end

    def lists_subscribed(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("lists/all.#{self.class.format}", options)
    end

    # :per_page = max number of statues to get at once
    # :page = which page of tweets you wish to get
    def list_timeline(list_owner_screen_name, slug, options={})
      perform_get("#{list_owner_screen_name}/lists/#{slug}/statuses.#{self.class.format}", options)
    end

    def retweets(id, options={})
      perform_get("statuses/retweets/#{id}.#{self.class.format}", options)
    end

    def friends(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/friends.#{self.class.format}", options)
    end

    def followers(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/followers.#{self.class.format}", options)
    end

    def rate_limit_status(options={})
      perform_get("account/rate_limit_status.#{self.class.format}", options)
    end

    def tos
      perform_get("legal/tos.#{self.class.format}")
    end

    def privacy
      perform_get("legal/privacy.#{self.class.format}")
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

  end
end

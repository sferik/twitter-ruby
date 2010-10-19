module Twitter
  class Unauthenticated
    extend ConfigHelper
    extend ConnectionHelper
    include RequestHelper

    def initialize(options={})
      @adapter = options[:adapter] || Twitter.adapter
      @api_endpoint = options[:api_endpoint] || Twitter.api_endpoint
      @api_version = options[:api_version] || Twitter.api_version
      @format = options[:format] || Twitter.format
      @protocol = options[:protocol] || Twitter.protocol
      @user_agent = options[:user_agent] || Twitter.user_agent
    end

    def firehose(options={})
      perform_get("statuses/public_timeline.#{@format}", options)
    end

    def user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("users/show.#{@format}", options)
    end

    def profile_image(screen_name, options={})
      self.class.connection_with_unparsed_response.get do |request|
        request.url("users/profile_image/#{screen_name}.#{@format}", options)
      end.headers["location"]
    end

    def suggestions(category_slug=nil, options={})
      path = case category_slug
      when nil
        "users/suggestions.#{@format}"
      when Hash
        options = category_slug
        "users/suggestions.#{@format}"
      else
        "users/suggestions/#{category_slug}.#{@format}"
      end
      perform_get(path, options)
    end

    def retweeted_to_user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/retweeted_to_user.#{@format}", options)
    end

    def retweeted_by_user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/retweeted_by_user.#{@format}", options)
    end

    def status(id, options={})
      perform_get("statuses/show/#{id}.#{@format}", options)
    end

    def friend_ids(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("friends/ids.#{@format}", options)
    end

    def follower_ids(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("followers/ids.#{@format}", options)
    end

    def timeline(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/user_timeline.#{@format}", options)
    end

    def lists_subscribed(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("lists/all.#{@format}", options)
    end

    # :per_page = max number of statues to get at once
    # :page = which page of tweets you wish to get
    def list_timeline(list_owner_screen_name, slug, options={})
      perform_get("#{list_owner_screen_name}/lists/#{slug}/statuses.#{@format}", options)
    end

    def retweets(id, options={})
      perform_get("statuses/retweets/#{id}.#{@format}", options)
    end

    def friends(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/friends.#{@format}", options)
    end

    def followers(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/followers.#{@format}", options)
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

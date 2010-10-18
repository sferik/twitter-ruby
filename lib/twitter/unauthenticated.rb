module Twitter
  class Unauthenticated

    def firehose(options = {})
      perform_get("statuses/public_timeline.#{Twitter.format}", options)
    end

    def user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("users/show.#{Twitter.format}", options)
    end

    def profile_image(screen_name, options={})
      Twitter.connection_with_unparsed_response.get do |request|
        request.url("users/profile_image/#{screen_name}.#{Twitter.format}", options)
      end.headers["location"]
    end

    def suggestions(category_slug=nil, options={})
      path = case category_slug
      when nil
        "users/suggestions.#{Twitter.format}"
      when Hash
        options = category_slug
        "users/suggestions.#{Twitter.format}"
      else
        "users/suggestions/#{category_slug}.#{Twitter.format}"
      end
      perform_get(path, options)
    end

    def retweeted_to_user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/retweeted_to_user.#{Twitter.format}", options)
    end

    def retweeted_by_user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/retweeted_by_user.#{Twitter.format}", options)
    end

    def status(id, options={})
      perform_get("statuses/show/#{id}.#{Twitter.format}", options)
    end

    def friend_ids(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("friends/ids.#{Twitter.format}", options)
    end

    def follower_ids(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("followers/ids.#{Twitter.format}", options)
    end

    def timeline(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("statuses/user_timeline.#{Twitter.format}", options)
    end

    def lists_subscribed(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      perform_get("lists/all.#{Twitter.format}", options)
    end

    # :per_page = max number of statues to get at once
    # :page = which page of tweets you wish to get
    def list_timeline(list_owner_screen_name, slug, options = {})
      perform_get("#{list_owner_screen_name}/lists/#{slug}/statuses.#{Twitter.format}", options)
    end

    private

    def perform_get(path, options={})
      results = Twitter.connection.get do |request|
        request.url(path, options)
      end.body
    end

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

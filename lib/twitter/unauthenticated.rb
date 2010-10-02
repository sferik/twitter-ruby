module Twitter
  class Unauthenticated

    def initialize(options={})
      @adapter = options.delete(:adapter)
      @api_endpoint = "api.twitter.com/#{Twitter.api_version}"
      @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
      @api_endpoint = @api_endpoint.to_s
    end

    def firehose(options = {})
      results = connection.get do |request|
        request.url "statuses/public_timeline.json", options
      end.body
    end

    def user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      results = connection.get do |request|
        request.url "users/show.json", options
      end.body
    end

    def suggestions(category_slug=nil, options={})
      path = case category_slug
      when nil
        "suggestions.json"
      when Hash
        options = category_slug
        "suggestions.json"
      else
        "users/suggestions/#{category_slug}/members.json"
      end
      results = connection.get do |request|
        request.url path, options
      end.body
    end

    def retweeted_to_user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      results = connection.get do |request|
        request.url "statuses/retweeted_to_user.json", options
      end.body
    end

    def retweeted_by_user(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      results = connection.get do |request|
        request.url "statuses/retweeted_by_user.json", options
      end.body
    end

    def status(id, options={})
      results = connection.get do |request|
        request.url "statuses/show/#{id}.json", options
      end.body
    end

    def friend_ids(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      results = connection.get do |request|
        request.url "friends/ids.json", options
      end.body
    end

    def follower_ids(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      results = connection.get do |request|
        request.url "followers/ids.json", options
      end.body
    end

    def timeline(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      results = connection.get do |request|
        request.url "statuses/user_timeline.json", options
      end.body
    end

    def lists_subscribed(user_id_or_screen_name, options={})
      merge_user_into_options!(user_id_or_screen_name, options)
      results = connection.get do |request|
        request.url "lists/all.json", options
      end.body
    end

    # :per_page = max number of statues to get at once
    # :page = which page of tweets you wish to get
    def list_timeline(list_owner_screen_name, slug, options = {})
      results = connection.get do |request|
        request.url "#{list_owner_screen_name}/lists/#{slug}/statuses.json", options
      end.body
    end

    def connection
      headers = {
        :user_agent => Twitter.user_agent
      }
      @connection ||= Faraday::Connection.new(:url => @api_endpoint, :headers => headers) do |builder|
        builder.adapter(@adapter || Faraday.default_adapter)
        builder.use Faraday::Response::RaiseErrors
        builder.use Faraday::Response::ParseJson
        builder.use Faraday::Response::Mashify
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

  end
end

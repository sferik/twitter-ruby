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

    def user(id, options={})
      results = connection.get do |request|
        request.url "users/show/#{id}.json", options
      end.body
    end

    def status(id, options={})
      results = connection.get do |request|
        request.url "statuses/show/#{id}.json", options
      end.body
    end

    def friend_ids(id, options={})
      results = connection.get do |request|
        request.url "friends/ids/#{id}.json", options
      end.body
    end

    def follower_ids(id, options={})
      results = connection.get do |request|
        request.url "followers/ids/#{id}.json", options
      end.body
    end

    def timeline(id, options={})
      results = connection.get do |request|
        request.url "statuses/user_timeline/#{id}.json", options
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
        builder.use Faraday::Response::MultiJson
        builder.use Faraday::Response::Mashify
      end
    end

  end
end

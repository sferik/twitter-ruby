require 'ostruct'
require 'forwardable'

module Twitter
  class Base
    extend Forwardable
    
    def_delegators :@client, :get, :post
    
    def initialize(oauth)
      @client = oauth.access_token
    end
    
    # Options: since_id, max_id, count, page, since
    def friends_timeline(options={})
      uri = URI.parse('/statuses/friends_timeline.json')
      uri.query = to_query(options) unless options == {}
      response = get(uri.to_s)
      Crack::JSON.parse(response.body).map { |tweet| Mash.new(tweet) }
    end
    
    # Options: id, user_id, screen_name, since_id, max_id, page, since
    def user_timeline(options={})
      uri = URI.parse('/statuses/user_timeline.json')
      uri.query = to_query(options) unless options == {}
      response = get(uri.to_s)
      Crack::JSON.parse(response.body).map { |tweet| Mash.new(tweet) }
    end
    
    # id Required. Id of the status to fetch.
    def status(id)
      response = get("/statuses/show/#{id}.json")
      Mash.new(Crack::JSON.parse(response.body))
    end
    
    private
      def to_query(options)
        options.inject([]) { |collection, opt| collection << "#{opt[0]}=#{opt[1]}"; collection } * '&'
      end
  end
end
# This is the base class for the twitter library. It makes all the requests 
# to twitter, parses the xml (using hpricot) and returns ruby objects to play with.
#
# The private methods in this one are pretty fun. Be sure to check out users, statuses and call.
module Twitter
  class Untwitterable < StandardError; end
  class CantConnect < Untwitterable; end
  class BadResponse < Untwitterable; end
  class UnknownTimeline < ArgumentError; end
  
  class Base
    
    # Twitter's url, duh!
    @@api_url   = 'twitter.com'
    
    # Timelines exposed by the twitter api
    @@timelines = [:friends, :public, :user]
    
    def self.timelines
      @@timelines
    end
    
    # Initializes the configuration for making requests to twitter
    def initialize(email, password)
      @config, @config[:email], @config[:password] = {}, email, password
    end
    
    # Returns an array of statuses for a timeline; 
    # Available timelines are determined from the @@timelines variable
    # Defaults to your friends timeline
    def timeline(which=:friends)
      raise UnknownTimeline unless @@timelines.include?(which)
      auth = which.to_s.include?('public') ? false : true
      statuses(call("#{which}_timeline", :auth => auth))
    end
    
    # Returns an array of users who are in your friends list
    def friends
      users(call(:friends))
    end
    
    # Returns an array of users who are following you
    def followers
      users(call(:followers))
    end
    
    # Updates your twitter with whatever status string is passed in
    def post(status)
      url = URI.parse("http://#{@@api_url}/statuses/update.xml")
      req = Net::HTTP::Post.new(url.path)
      
      req.basic_auth(@config[:email], @config[:password])
      req.set_form_data({'status' => status})
      
      result = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
      Status.new_from_xml(Hpricot.XML(result.body).at('status'))
    end
    alias :update :post
    
    private      
      # Converts xml to an array of statuses
      def statuses(doc)
        (doc/:status).inject([]) { |statuses, status| statuses << Status.new_from_xml(status); statuses }
      end
      
      # Converts xml to an array of users
      def users(doc)
        (doc/:user).inject([]) { |users, user| users << User.new_from_xml(user); users }
      end
      
      # Calls whatever api method requested
      # 
      # ie: call(:public_timeline, :auth => false)
      def call(method, arg_options={})
        options = { :auth => true }.merge(arg_options)
        path    = "/statuses/#{method.to_s}.xml"
        headers = { "User-Agent" => @config[:email] }
        
        begin
          response = Net::HTTP.start(@@api_url, 80) do |http|
              req = Net::HTTP::Get.new(path, headers)
              req.basic_auth(@config[:email], @config[:password]) if options[:auth]
              http.request(req)
          end

          raise BadResponse unless response.message == 'OK'
          Hpricot.XML(response.body)
        rescue
          raise CantConnect
        end
      end
  end
end
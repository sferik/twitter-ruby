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
    
    # Returns an array of users who are friends for the id or username passed in
    def friends_for(id)
      users(call(:friends, {:args => {:id => id}}))
    end
    
    # Returns an array of users who are following you
    def followers
      users(call(:followers))
    end
    
    # waiting for twitter to correclty implement this in the api as it is documented
    # TODO: uncomment this when it is working
    # def featured
    #   users(call(:featured))
    # end
    
    # Returns an array of all the direct messages for the authenticated user
    #
    #   <tt>since</tt> - (optional) Narrows the resulting list of direct messages to just those sent after the specified HTTP-formatted date.
    def direct_messages(since=nil)
      path = 'direct_messages.xml'
      since.nil? ? 1 : path << "?since=#{CGI.escape(since.to_s)}"
      doc = request(path, { :auth => true })
      (doc/:direct_message).inject([]) { |dms, dm| dms << DirectMessage.new_from_xml(dm); dms }
    end
    
    # This api methods doesn't seem to be working
    # TODO: uncomment this when it is working
    # def d(user, msg)
    #   url = URI.parse("http://#{@@api_url}/statuses/update.xml")
    #   
    #   req = Net::HTTP::Post.new(url.path)
    #   req.basic_auth(@config[:email], @config[:password])
    #   req.set_form_data({'user' => user, 'msg' => msg})
    #   
    #   response = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    #   puts response.message,response.body
    # end
    
    # Updates your twitter with whatever status string is passed in
    def post(status)
      url = URI.parse("http://#{@@api_url}/statuses/update.xml")
      req = Net::HTTP::Post.new(url.path)
      
      req.basic_auth(@config[:email], @config[:password])
      req.set_form_data({'status' => status})
      
      response = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
      Status.new_from_xml(parse(response.body).at('status'))
    end
    alias :update :post
    
    private
      # Converts an hpricot doc to an array of statuses
      def statuses(doc)
        (doc/:status).inject([]) { |statuses, status| statuses << Status.new_from_xml(status); statuses }
      end
      
      # Converts an hpricot doc to an array of users
      def users(doc)
        (doc/:user).inject([]) { |users, user| users << User.new_from_xml(user); users }
      end
      
      # Calls whatever api method requested that deals with statuses
      # 
      # ie: call(:public_timeline, :auth => false)
      def call(method, options={})
        options.reverse_merge!({ :auth => true, :args => {} })
        path    = "statuses/#{method.to_s}.xml"
        path   += '?' + options[:args].inject('') { |qs, h| qs += "#{h[0]}=#{h[1]}&"; qs } unless options[:args].blank?        
        request(path, options)
      end
      
      def request(path, options)
        options.reverse_merge!({:headers => { "User-Agent" => @config[:email] }})
        begin
          response = Net::HTTP.start(@@api_url, 80) do |http|
              req = Net::HTTP::Get.new('/' + path, options[:headers])
              req.basic_auth(@config[:email], @config[:password]) if options[:auth]
              http.request(req)
          end

          raise BadResponse unless response.message == 'OK'
          parse(response.body)
        rescue
          raise CantConnect
        end
      end
      
      def parse(response)
        Hpricot.XML(response)
      end
  end
end
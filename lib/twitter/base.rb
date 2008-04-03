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
    def timeline(which=:friends, since=nil)
      raise UnknownTimeline unless @@timelines.include?(which)
      auth = which.to_s.include?('public') ? false : true
      statuses(call("#{which}_timeline", :auth => auth, :since => since))
    end
    
    # Returns an array of users who are in your friends list
    def friends(lite = false)
      users(call(:friends, {:args => {:lite => lite}}))
    end
    
    # Returns an array of users who are friends for the id or username passed in
    def friends_for(id, lite = false)
      users(call(:friends, {:args => {:id => id, :lite => lite}}))
    end
    
    # Returns an array of users who are following you
    def followers(lite = false)
      users(call(:followers, {:args => {:lite => lite}}))
    end
    
    # Returns a single status for a given id
    def status(id)
      statuses(call("show/#{id}")).first
    end
    
    # returns all the profile information and the last status for a user
    def user(id_or_screenname)
      users(request("users/show/#{id_or_screenname}.xml", :auth => true)).first
    end
    
    # Returns an array of statuses that are replies
    def replies(since=nil)
      statuses(call(:replies, :since => since))
    end
    
    # Destroys a status by id
    def destroy(id)
      call("destroy/#{id}")
    end
    
    # waiting for twitter to correctly implement this in the api as it is documented
    def featured
      users(call(:featured))
    end
    
    # Returns an array of all the direct messages for the authenticated user
    #
    #   <tt>since</tt> - (optional) Narrows the resulting list of direct messages to just those sent after the specified HTTP-formatted date.
    # TODO: allow page for direct messages
    def direct_messages(since=nil)
      path = 'direct_messages.xml'
      doc = request(path, { :auth => true, :since => since })
      (doc/:direct_message).inject([]) { |dms, dm| dms << DirectMessage.new_from_xml(dm); dms }
    end
    alias :received_messages :direct_messages
    
    # Returns 20 direct messages sent by auth user
    # TODO: allow page for sent messages
    def sent_messages(since=nil)
      path = 'direct_messages/sent.xml'
      doc = request(path, { :auth => true, :since => since })
      (doc/:direct_message).inject([]) { |dms, dm| dms << DirectMessage.new_from_xml(dm); dms }
    end
    
    # destroys a give direct message by id if the auth user is a recipient
    # TODO: return http status code
    def destroy_direct_message(id)
      request("direct_messages/destroy/#{id}.xml", :auth => true)
    end
    
    # Sends a direct message <code>text</code> to <code>user</code>
    def d(user, text)
      url = URI.parse("http://#{@@api_url}/direct_messages/new.xml")
      req = Net::HTTP::Post.new(url.path)
      
      req.basic_auth(@config[:email], @config[:password])
      req.set_form_data({'text' => text, 'user' => user})
      
      response = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
      DirectMessage.new_from_xml(parse(response.body).at('direct_message'))
    end
    
    # Befriends the user specified in the ID parameter as the authenticating user.
    def create_friendship(id_or_screenname)
      users(request("friendships/create/#{id_or_screenname}.xml", :auth => true)).first
    end
    
    def destroy_friendship(id_or_screenname)
      users(request("friendships/destroy/#{id_or_screenname}.xml", :auth => true)).first
    end
    
    def follow(id_or_screenname)
      users(request("notifications/follow/#{id_or_screenname}.xml", :auth => true)).first
    end
    
    def leave(id_or_screenname)
      users(request("notifications/leave/#{id_or_screenname}.xml", :auth => true)).first
    end
    
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
        # Following line needed as lite=false doens't work in the API: http://tinyurl.com/yo3h5d
        options[:args].delete(:lite) unless options[:args][:lite]
        path    = "statuses/#{method.to_s}.xml"
        path   += '?' + options[:args].inject('') { |qs, h| qs += "#{h[0]}=#{h[1]}&"; qs } unless options[:args].blank?        
        request(path, options)
      end
      
      def request(path, options={})
        options.reverse_merge!({:headers => { "User-Agent" => @config[:email] }})
        unless options[:since].blank?
          since = options[:since].kind_of?(Date) ? options[:since].strftime('%a, %d-%b-%y %T GMT') : options[:since].to_s  
          options[:headers]["If-Modified-Since"] = since
        end
        
        begin
          response = Net::HTTP.start(@@api_url, 80) do |http|
              req = Net::HTTP::Get.new('/' + path, options[:headers])
              req.basic_auth(@config[:email], @config[:password]) if options[:auth]
              http.request(req)
          end

          raise BadResponse unless response.message == 'OK' || response.message == 'Not Modified'
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
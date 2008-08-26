# This is the base class for the twitter library. It makes all the requests 
# to twitter, parses the xml (using hpricot) and returns ruby objects to play with.
#
# For complete documentation on the options, check out the twitter api docs.
#   http://groups.google.com/group/twitter-development-talk/web/api-documentation
module Twitter
  class Base
    # Initializes the configuration for making requests to twitter
    # Twitter example:
    #   Twitter.new('email/username', 'password')
    #
    # Identi.ca example:
    #   Twitter.new('email/username', 'password', :api_host => 'identi.ca/api')
    def initialize(email, password, options={})
      @config, @config[:email], @config[:password] = {}, email, password
      @api_host = options.delete(:api_host) || 'twitter.com'
    end
    
    # Returns an array of statuses for a timeline; Defaults to your friends timeline.
    def timeline(which=:friends, options={})
      raise UnknownTimeline unless [:friends, :public, :user].include?(which)
      auth = which.to_s.include?('public') ? false : true
      statuses(call("#{which}_timeline", :auth => auth, :since => options[:since], :args => parse_options(options)))
    end
    
    # Returns an array of users who are in your friends list
    def friends(options={})
      users(call(:friends, {:args => parse_options(options)}))
    end
    
    # Returns an array of users who are friends for the id or username passed in
    def friends_for(id, options={})
      friends(options.merge({:id => id}))
    end
    
    # Returns an array of users who are following you
    def followers(options={})
      users(call(:followers, {:args => parse_options(options)}))
    end
    
    def followers_for(id, options={})
      followers(options.merge({:id => id}))
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
    def replies(options={})
      statuses(call(:replies, :since => options[:since], :args => parse_options(options)))
    end
    
    # Destroys a status by id
    def destroy(id)
      call("destroy/#{id}")
    end
    
    def rate_limit_status
      RateLimitStatus.new_from_xml request("account/rate_limit_status.xml", :auth => true)
    end
    
    # waiting for twitter to correctly implement this in the api as it is documented
    def featured
      users(call(:featured))
    end
    
    # Returns an array of all the direct messages for the authenticated user
    def direct_messages(options={})
      doc = request(build_path('direct_messages.xml', parse_options(options)), {:auth => true, :since => options[:since]})
      (doc/:direct_message).inject([]) { |dms, dm| dms << DirectMessage.new_from_xml(dm); dms }
    end
    alias :received_messages :direct_messages
    
    # Returns direct messages sent by auth user
    def sent_messages(options={})
      doc = request(build_path('direct_messages/sent.xml', parse_options(options)), {:auth => true, :since => options[:since]})
      (doc/:direct_message).inject([]) { |dms, dm| dms << DirectMessage.new_from_xml(dm); dms }
    end
    
    # destroys a give direct message by id if the auth user is a recipient
    def destroy_direct_message(id)
      DirectMessage.new_from_xml(request("direct_messages/destroy/#{id}.xml", :auth => true, :method => :post))
    end
    
    # Sends a direct message <code>text</code> to <code>user</code>
    def d(user, text)
      DirectMessage.new_from_xml(request('direct_messages/new.xml', :auth => true, :method => :post, :form_data => {'text' => text, 'user' => user}))
    end
    
    # Befriends id_or_screenname for the auth user
    def create_friendship(id_or_screenname)
      users(request("friendships/create/#{id_or_screenname}.xml", :auth => true, :method => :post)).first
    end
    
    # Defriends id_or_screenname for the auth user
    def destroy_friendship(id_or_screenname)
      users(request("friendships/destroy/#{id_or_screenname}.xml", :auth => true, :method => :post)).first
    end
    
    # Returns true if friendship exists, false if it doesn't.
    def friendship_exists?(user_a, user_b)
      doc = request(build_path("friendships/exists.xml", {:user_a => user_a, :user_b => user_b}), :auth => true)
      doc.at('friends').innerHTML == 'true' ? true : false
    end
    
    # Updates your location and returns Twitter::User object
    def update_location(location)
      users(request(build_path('account/update_location.xml', {'location' => location}), :auth => true, :method => :post)).first
    end
    
    # Updates your deliver device and returns Twitter::User object
    def update_delivery_device(device)
      users(request(build_path('account/update_delivery_device.xml', {'device' => device}), :auth => true, :method => :post)).first
    end
    
    # Turns notifications by id_or_screenname on for auth user.
    def follow(id_or_screenname)
      users(request("notifications/follow/#{id_or_screenname}.xml", :auth => true, :method => :post)).first
    end

    # Turns notifications by id_or_screenname off for auth user.    
    def leave(id_or_screenname)
      users(request("notifications/leave/#{id_or_screenname}.xml", :auth => true, :method => :post)).first
    end
    
    # Returns the most recent favorite statuses for the autenticating user
    def favorites(options={})
      statuses(request(build_path('favorites.xml', parse_options(options)), :auth => true))
    end
    
    # Favorites the status specified by id for the auth user
    def create_favorite(id)
      statuses(request("favorites/create/#{id}.xml", :auth => true, :method => :post)).first
    end

    # Un-favorites the status specified by id for the auth user
    def destroy_favorite(id)
      statuses(request("favorites/destroy/#{id}.xml", :auth => true, :method => :post)).first
    end
    
    # Blocks the user specified by id for the auth user
    def block(id)
      users(request("blocks/create/#{id}.xml", :auth => true, :method => :post)).first
    end
    
    # Unblocks the user specified by id for the auth user
    def unblock(id)
      users(request("blocks/destroy/#{id}.xml", :auth => true, :method => :post)).first
    end
    
    # Posts a new update to twitter for auth user.
    def post(status, options={})
      form_data = {'status' => status}
      form_data.merge!({'source' => options[:source]}) if options[:source]
      Status.new_from_xml(request('statuses/update.xml', :auth => true, :method => :post, :form_data => form_data))
    end
    alias :update :post
    
    # Verifies the credentials for the auth user.
    #   raises Twitter::CantConnect on failure.
    def verify_credentials
      request('account/verify_credentials', :auth => true)
    end
    
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
        # Following line needed as lite=false doesn't work in the API: http://tinyurl.com/yo3h5d
        options[:args].delete(:lite) unless options[:args][:lite]
        args = options.delete(:args)
        request(build_path("statuses/#{method.to_s}.xml", args), options)
      end
      
      # Makes a request to twitter.
      def request(path, options={})
        options.reverse_merge!({
          :headers => { "User-Agent" => @config[:email] },
          :method => :get
        })
        unless options[:since].blank?
          since = options[:since].kind_of?(Date) ? options[:since].strftime('%a, %d-%b-%y %T GMT') : options[:since].to_s  
          options[:headers]["If-Modified-Since"] = since
        end
        
        uri = URI.parse("http://#{@api_host}")
        
        begin
          response = Net::HTTP.start(uri.host, 80) do |http|
            klass = Net::HTTP.const_get options[:method].to_s.downcase.capitalize
            req = klass.new("#{uri.path}/#{path}", options[:headers])
            req.basic_auth(@config[:email], @config[:password]) if options[:auth]
            if options[:method].to_s == 'post' && options[:form_data]
              req.set_form_data(options[:form_data])
            end
            http.request(req)
          end
        rescue => error
          raise CantConnect, error.message
        end
        
        if %w[200 304].include?(response.code)
          response = parse(response.body)
          raise RateExceeded if (response/:hash/:error).text =~ /Rate limit exceeded/
          response
        elsif response.code == '503'
          raise Unavailable, response.message
        elsif response.code == '401'
          raise CantConnect, 'Authentication failed. Check your username and password'
        else
          raise CantConnect, "Twitter is returning a #{response.code}: #{response.message}"
        end
      end      
    
      # Given a path and a hash, build a full path with the hash turned into a query string
      def build_path(path, options)
        path += "?#{options.to_query}" unless options.blank?
        path
      end

      # Tries to get all the options in the correct format before making the request
      def parse_options(options)
        options[:since] = options[:since].kind_of?(Date) ? options[:since].strftime('%a, %d-%b-%y %T GMT') : options[:since].to_s if options[:since]
        options
      end
      
      # Converts a string response into an Hpricot xml element.
      def parse(response)
        Hpricot.XML(response || '')
      end
  end
end
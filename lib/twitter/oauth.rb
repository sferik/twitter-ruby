module Twitter
  class OAuth
    extend Forwardable
    def_delegators :access_token, :get, :post
    
    attr_reader :ctoken, :csecret, :consumer_options
    
    # Options
    #   :sign_in => true to just sign in with twitter instead of doing oauth authorization
    #               (http://apiwiki.twitter.com/Sign-in-with-Twitter)
    def initialize(ctoken, csecret, options={})
      @ctoken, @csecret, @consumer_options = ctoken, csecret, {}
      
      if options[:sign_in]
        @consumer_options[:authorize_path] =  '/oauth/authenticate'
      end
    end
    
    def consumer
      @consumer ||= ::OAuth::Consumer.new(@ctoken, @csecret, {:site => 'http://twitter.com'}.merge(consumer_options))
    end
    
    def request_token
      @request_token ||= consumer.get_request_token
    end
    
    def authorize_from_request(rtoken, rsecret)
      request_token = ::OAuth::RequestToken.new(consumer, rtoken, rsecret)
      access_token = request_token.get_access_token
      @atoken, @asecret = access_token.token, access_token.secret
    end
    
    def access_token
      @access_token ||= ::OAuth::AccessToken.new(consumer, @atoken, @asecret)
    end
    
    def authorize_from_access(atoken, asecret)
      @atoken, @asecret = atoken, asecret
    end
  end
end
module Twitter
  class OAuth    
    attr_reader :token, :secret
    
    def initialize(ctoken, csecret)
      @ctoken, @csecret = ctoken, csecret
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
    
    private
      def consumer
        @consumer ||= ::OAuth::Consumer.new(@ctoken, @csecret, {:site => 'http://twitter.com'})
      end
  end
end
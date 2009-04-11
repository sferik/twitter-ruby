module Twitter
  class HTTPAuth
    include HTTParty
    base_uri 'http://twitter.com'
    format :plain
    
    attr_reader :username, :password
    
    def initialize(username, password)
      @username, @password = username, password
    end
    
    def get(uri, headers={})
      self.class.get(uri, :headers => headers, :basic_auth => basic_auth)
    end
    
    def post(uri, body={}, headers={})
      self.class.post(uri, :body => body, :headers => headers, :basic_auth => basic_auth)
    end
    
    private
      def basic_auth
        @basic_auth ||= {:username => @username, :password => @password}
      end
  end
end
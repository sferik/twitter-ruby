module Twitter
  class HTTPAuth
    include HTTParty

    format :plain

    attr_reader :username, :password, :options

    def initialize(username, password, options={})
      warn "[DEPRECATION] Baic auth is deprecated as Twitter is ending support in June 2010. Please migrate to OAuth."
      
      @username, @password = username, password
      @options = {:ssl => false}.merge(options)
      options[:api_endpoint] ||= "api.twitter.com"
      self.class.base_uri "http#{'s' if options[:ssl]}://#{options[:api_endpoint]}"
    end

    def get(uri, headers={})
      warn "[DEPRECATION] Baic auth is deprecated as Twitter is ending support in June 2010. Please migrate to OAuth."
      
      self.class.get(uri, :headers => headers, :basic_auth => basic_auth)
    end

    def post(uri, body={}, headers={})
      warn "[DEPRECATION] Baic auth is deprecated as Twitter is ending support in June 2010. Please migrate to OAuth."
      
      self.class.post(uri, :body => body, :headers => headers, :basic_auth => basic_auth)
    end

    def put(uri, body={}, headers={})
      warn "[DEPRECATION] Baic auth is deprecated as Twitter is ending support in June 2010. Please migrate to OAuth."
      
      self.class.put(uri, :body => body, :headers => headers, :basic_auth => basic_auth)
    end

    def delete(uri, body={}, headers={})
      warn "[DEPRECATION] Baic auth is deprecated as Twitter is ending support in June 2010. Please migrate to OAuth."
      
      self.class.delete(uri, :body => body, :headers => headers, :basic_auth => basic_auth)
    end

    private

    def basic_auth
      @basic_auth ||= {:username => @username, :password => @password}
    end

  end
end

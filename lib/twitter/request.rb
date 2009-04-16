module Twitter
  class Request
    extend Forwardable
    
    def self.get(client, path, options={})
      new(client, :get, path, options).perform
    end
    
    def self.post(client, path, options={})
      new(client, :post, path, options).perform
    end
    
    attr_reader :client, :method, :path, :options
    
    def_delegators :client, :get, :post
    
    def initialize(client, method, path, options={})
      @client, @method, @path, @options = client, method, path, {:mash => true}.merge(options)
    end
    
    def uri
      @uri ||= begin
        uri = URI.parse(path)
        
        if options[:query] && options[:query] != {}
          uri.query = to_query(options[:query])
        end
        
        uri.to_s
      end
    end
    
    def perform
      make_friendly(send("perform_#{method}"))
    end
    
    private
      def perform_get
        send(:get, uri, options[:headers])
      end
      
      def perform_post
        send(:post, uri, options[:body], options[:headers])
      end
      
      def make_friendly(response)
        raise_errors(response)
        data = parse(response)
        options[:mash] ? mash(data) : data
      end
      
      def raise_errors(response)
        case response.code.to_i
          when 400
            data = parse(response)
            raise RateLimitExceeded.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
          when 401
            data = parse(response)
            raise Unauthorized.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
          when 403
            data = parse(response)
            raise General.new(data), "(#{response.code}): #{response.message} - #{data['error'] if data}"
          when 404
            raise NotFound, "(#{response.code}): #{response.message}"
          when 500
            raise InformTwitter, "Twitter had an internal error. Please let them know in the group. (#{response.code}): #{response.message}"
          when 502..503
            raise Unavailable, "(#{response.code}): #{response.message}"
        end
      end
      
      def parse(response)
        Crack::JSON.parse(response.body)
      end
      
      def mash(obj)
        if obj.is_a?(Array)
          obj.map { |item| make_mash_with_consistent_hash(item) }
        elsif obj.is_a?(Hash)
          make_mash_with_consistent_hash(obj)
        else
          obj
        end
      end

      # Lame workaround for the fact that mash doesn't hash correctly
      def make_mash_with_consistent_hash(obj)
        m = Mash.new(obj)
        def m.hash
          inspect.hash
        end
        return m
      end
      
      def to_query(options)
        options.inject([]) do |collection, opt| 
          collection << "#{opt[0]}=#{opt[1]}"
          collection
        end * '&'
      end
  end
end
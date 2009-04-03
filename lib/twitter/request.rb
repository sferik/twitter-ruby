module Twitter
  class Request
    extend Forwardable
    
    def self.get(base, path, options={})
      new(base, :get, path, options).perform
    end
    
    attr_reader :base, :method, :path, :options
    
    def_delegators :base, :get, :post
    
    def initialize(base, method, path, options={})
      @base, @method, @path, @options = base, method, path, options
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
      make_friendly(send(method, uri))
    end
    
    private
      def make_friendly(response)
        mash(parse(response))
      end
    
      def parse(response)
        Crack::JSON.parse(response.body)
      end
      
      def mash(obj)
        if obj.is_a?(Array)
          obj.map { |item| Mash.new(item) }
        else
          Mash.new(obj)
        end
      end
      
      def to_query(options)
        options.inject([]) do |collection, opt| 
          collection << "#{opt[0]}=#{opt[1]}"
          collection
        end * '&'
      end
  end
end
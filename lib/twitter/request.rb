module Twitter
  class Request
    extend Forwardable

    def self.get(client, path, options={})
      new(client, :get, path, options).perform_get
    end

    def self.post(client, path, options={})
      new(client, :post, path, options).perform_post
    end

    def self.put(client, path, options={})
      new(client, :put, path, options).perform_put
    end

    def self.delete(client, path, options={})
      new(client, :delete, path, options).perform_delete
    end

    attr_reader :client, :method, :path, :options

    def_delegators :client, :get, :post, :put, :delete

    def initialize(client, method, path, options={})
      @client, @method, @path, @options = client, method, path, options
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

    def connection
      headers = {
        :user_agent => Twitter.user_agent
      }
      @connection ||= Faraday::Connection.new(:url => Twitter.api_endpoint, :headers => headers) do |builder|
        builder.adapter(@adapter || Faraday.default_adapter)
        builder.use Faraday::Response::RaiseErrors
        builder.use Faraday::Response::MultiJson
        builder.use Faraday::Response::Mashify
      end
    end

    def perform_get
      results = connection.get do |req|
        req.url uri
      end.body
    end

    def perform_post
      results = connection.post do |req|
        req.url uri, options[:body]
      end.body
    end

    def perform_put
      results = connection.put do |req|
        req.url uri, options[:body]
      end.body
    end

    def perform_delete
      results = connection.delete do |req|
        req.url uri
      end.body
    end

    private

    def to_query(options)
      options.inject([]) do |collection, opt|
        collection << "#{opt[0]}=#{opt[1]}"
        collection
      end * '&'
    end

  end
end

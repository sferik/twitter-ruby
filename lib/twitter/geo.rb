module Twitter
  class Geo

    def initialize(options={})
      @adapter = options.delete(:adapter)
      @api_endpoint = "api.twitter.com/#{Twitter.api_version}/geo"
      @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
      @api_endpoint = @api_endpoint.to_s
    end

    def place(place_id, options={})
      results = connection.get do |req|
        req.url "id/#{place_id}.json", options
      end.body
      results
    end

    def search(options={})
      results = connection.get do |req|
        req.url "search.json", options
      end.body
      results.result.values.flatten
    end

    def reverse_geocode(options={})
      results = connection.get do |req|
        req.url "reverse_geocode.json", options
      end.body
      results.result.values.flatten
    end

    def connection
      headers = {
        :user_agent => Twitter.user_agent
      }
      @connection ||= Faraday::Connection.new(:url => @api_endpoint, :headers => headers) do |builder|
        builder.adapter(@adapter || Faraday.default_adapter)
        builder.use Faraday::Response::MultiJson
        builder.use Faraday::Response::Mashify
      end
    end

  end
end

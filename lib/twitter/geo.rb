module Twitter
  class Geo
    include HTTParty
    base_uri "api.twitter.com/#{API_VERSION}/geo"
    format :json

    def self.place(place_id, query={})
      Twitter.mash(get("/id/#{place_id}.json", :query => query))
    end

    def self.search(query={})
      mashup(get("/search.json", :query => query))
    end

    def self.reverse_geocode(query={})
      mashup(get("/reverse_geocode.json", :query => query))
    end

    private

      def self.mashup(response)
        response["result"].values.flatten.map{|t| Twitter.mash(t)}
      end
  end
end

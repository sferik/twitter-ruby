module Twitter
  class Client
    module Geo
      def geo_search(options={})
        get('geo/search', options)
      end

      def similar_places(options={})
        get('geo/similar_places', options)
      end

      def reverse_geocode(options={})
        get('geo/reverse_geocode', options)
      end

      def place(id, options={})
        get("geo/id/#{id}", options)
      end

      def create_place(options={})
        authenticate!
        post('geo/place', options)
      end
    end
  end
end

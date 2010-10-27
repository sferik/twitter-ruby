module Twitter
  class Client
    module Geo
      def places_nearby(options={})
        get('geo/search', options)['result']['places']
      end

      alias :geo_search :places_nearby

      def places_similar(options={})
        get('geo/similar_places', options)['result']['places']
      end

      def reverse_geocode(options={})
        get('geo/reverse_geocode', options)['result']['places']
      end

      def place(id, options={})
        get("geo/id/#{id}", options)
      end

      def place_create(options={})
        post('geo/place', options)
      end
    end
  end
end

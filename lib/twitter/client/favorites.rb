module Twitter
  class Client
    module Favorites
      def favorites(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.first
        response = get(['favorites', user].compact.join('/'), options)
        format.to_s.downcase == 'xml' ? response.statuses : response
      end

      def favorite_create(id, options={})
        response = post("favorites/create/#{id}", options)
        format.to_s.downcase == 'xml' ? response.status : response
      end

      def favorite_destroy(id, options={})
        response = delete("favorites/destroy/#{id}", options)
        format.to_s.downcase == 'xml' ? response.status : response
      end
    end
  end
end

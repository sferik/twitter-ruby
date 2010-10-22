module Twitter
  class Client
    module Favorites
      def favorites(*args)
        authenticate!
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.first
        get(['favorites', user].compact.join('/'), options)
      end

      def favorite_create(id, options={})
        authenticate!
        post("favorites/create/#{id}", options)
      end

      def favorite_destroy(id, options={})
        authenticate!
        delete("favorites/destroy/#{id}", options)
      end
    end
  end
end

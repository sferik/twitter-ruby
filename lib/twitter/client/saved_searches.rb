module Twitter
  class Client
    module SavedSearches
      def saved_searches(options={})
        get('saved_searches', options)
      end

      def saved_search(id, options={})
        get("saved_searches/show/#{id}", options)
      end

      def saved_search_create(query, options={})
        post('saved_searches/create', options.merge(:query => query))
      end

      def saved_search_destroy(id, options={})
        delete("saved_searches/destroy/#{id}", options)
      end
    end
  end
end

module Twitter
  class Client
    module SavedSearches
      def saved_searches(options={})
        response = get('saved_searches', options)
        format.to_s.downcase == 'xml' ? response['saved_searches'] : response
      end

      def saved_search(id, options={})
        response = get("saved_searches/show/#{id}", options)
        format.to_s.downcase == 'xml' ? response['saved_search'] : response
      end

      def saved_search_create(query, options={})
        response = post('saved_searches/create', options.merge(:query => query))
        format.to_s.downcase == 'xml' ? response['saved_search'] : response
      end

      def saved_search_destroy(id, options={})
        response = delete("saved_searches/destroy/#{id}", options)
        format.to_s.downcase == 'xml' ? response['saved_search'] : response
      end
    end
  end
end

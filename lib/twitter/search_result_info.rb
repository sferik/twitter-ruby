module Twitter
  class SearchResultInfo < Hash
    
    # Creates an easier to work with hash from
    # one with string-based keys
    def self.new_from_hash(hash)
      i = new
      i.merge!(hash)
      search_results = []
      i.results.each do |r|
        search_results << SearchResult.new_from_hash(r)
      end
      i.results = search_results
      i
    end
    
    def completed_in
      self['completed_in']
    end
    
    def completed_in=(val)
      self['completed_in'] = val
    end
    
    def max_id
      self['max_id']
    end
    
    def max_id=(val)
      self['max_id'] = val
    end
    
    def next_page
      self['next_page']
    end
    
    def next_page=(val)
      self['next_page'] = val
    end
    
    def page
      self['page']
    end
    
    def page=(val)
      self['page'] = val
    end
    
    def refresh_url
      self['refresh_url']
    end
    
    def refresh_url=(val)
      self['refresh_url'] = val
    end
    
    def results_per_page
      self['results_per_page']
    end
    
    def results_per_page=(val)
      self['results_per_page'] = val
    end
    
    def since_id
      self['since_id']
    end
    
    def since_id=(val)
      self['since_id'] = val
    end
    
    def results
      self['results']
    end
    
    def results=(val)
      self['results'] = val
    end
    
  end
end
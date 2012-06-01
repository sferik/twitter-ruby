require 'twitter/base'

module Twitter
  class SearchResults < Twitter::Base

    # @return [Array<Twitter::Status>]
    def results
      @results ||= (@attrs['results'] || []).map{ |status| Twitter::Status.new(status) }
    end
    alias :collection :results

    # @return [Float]
    def completed_in
      @attrs['completed_in']
    end

    # @return [Fixnum]
    def max_id
      @attrs['max_id']
    end

    # @return [String]
    def max_id_str
      @attrs['max_id_str']
    end

    # @return [String]
    def next_page
      @attrs['next_page']
    end

    # @return [Fixnum]
    def page
      @attrs['page']
    end

    # @return [String]
    def query
      @attrs['query']
    end

    # @return [String]
    def refresh_url
      @attrs['refresh_url']
    end

    # @return [Fixnum]
    def results_per_page
      @attrs['results_per_page']
    end

    # @return [Fixnum]
    def since_id
      @attrs['since_id']
    end

    # @return [String]
    def since_id_str
      @attrs['since_id_str']
    end
  end
end
    

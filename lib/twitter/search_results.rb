require 'twitter/base'

module Twitter
  class SearchResults < Twitter::Base
    attr_reader :completed_in, :max_id, :next_page, :page, :query,
      :refresh_url, :results_per_page, :since_id

    # @return [Array<Twitter::Status>]
    def results
      @results ||= Array(@attrs['results']).map{|status| Twitter::Status.get_or_new(status)}
    end
    alias :collection :results

  end
end

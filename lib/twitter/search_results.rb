require 'twitter/base'
require 'twitter/tweet'

module Twitter
  class SearchResults < Twitter::Base
    attr_reader :completed_in, :max_id, :next_page, :page, :query,
      :refresh_url, :results_per_page, :since_id

    # @return [Array<Twitter::Tweet>]
    def results
      @results ||= Array(@attrs[:results]).map do |tweet|
        Twitter::Tweet.fetch_or_new(tweet)
      end
    end
    alias collection results

  end
end

require 'twitter/base'
require 'twitter/tweet'

module Twitter
  class SearchResults < Twitter::Base

    # @return [Array<Twitter::Tweet>]
    def statuses
      @results ||= Array(@attrs[:statuses]).map do |tweet|
        Twitter::Tweet.fetch_or_new(tweet)
      end
    end
    alias collection statuses
    alias results statuses

    # @return [Float]
    def completed_in
      @attrs[:search_metadata][:completed_in] unless @attrs[:search_metadata].nil?
    end

    # @return [Integer]
    def max_id
      @attrs[:search_metadata][:max_id] unless @attrs[:search_metadata].nil?
    end

    # @return [Integer]
    def page
      @attrs[:search_metadata][:page] unless @attrs[:search_metadata].nil?
    end

    # @return [String]
    def query
      @attrs[:search_metadata][:query] unless @attrs[:search_metadata].nil?
    end

    # @return [Integer]
    def results_per_page
      @attrs[:search_metadata][:results_per_page] unless @attrs[:search_metadata].nil?
    end
    alias rpp results_per_page

    # @return [Integer]
    def since_id
      @attrs[:search_metadata][:since_id] unless @attrs[:search_metadata].nil?
    end

  end
end

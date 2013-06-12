require 'twitter/base'

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
      @attrs[:search_metadata][:completed_in] if search_metadata?
    end

    # @return [Integer]
    def max_id
      @attrs[:search_metadata][:max_id] if search_metadata?
    end

    # @return [Integer]
    def page
      @attrs[:search_metadata][:page] if search_metadata?
    end

    # @return [String]
    def query
      @attrs[:search_metadata][:query] if search_metadata?
    end

    # @return [Integer]
    def results_per_page
      @attrs[:search_metadata][:results_per_page] if search_metadata?
    end
    alias rpp results_per_page

    def search_metadata?
      !@attrs[:search_metadata].nil?
    end

    # @return [Integer]
    def since_id
      @attrs[:search_metadata][:since_id] if search_metadata?
    end

    # @return [Boolean]
    def next_results?
      !@attrs[:search_metadata][:next_results].nil? if search_metadata?
    end
    alias next_page? next_results?

    # Returns a Hash of query parameters for the next result in the search
    #
    # @note Returned Hash can be merged into the previous search options list to easily access the next page.
    # @return [Hash] The parameters needed to fetch the next page.
    def next_results
      if next_results?
        query_string = strip_first_character(@attrs[:search_metadata][:next_results])
        query_string_to_hash(query_string)
      end
    end
    alias next_page next_results

    # Returns a Hash of query parameters for the refresh URL in the search
    #
    # @note Returned Hash can be merged into the previous search options list to easily access the refresh page.
    # @return [Hash] The parameters needed to refresh the page.
    def refresh_url
      query_string = strip_first_character(@attrs[:search_metadata][:refresh_url])
      query_string_to_hash(query_string)
    end
    alias refresh_page refresh_url

  private

    # Returns the string with the first character removed
    #
    # @param string [String]
    # @return [String] A copy of string without the first character.
    # @example Returns the query string with the question mark removed
    #   strip_first_character("?foo=bar&baz=qux") #=> "foo=bar&baz=qux"
    def strip_first_character(string)
      strip_first_character!(string.dup)
    end

    # Removes the first character from a string
    #
    # @param string [String]
    # @return [String] The string without the first character.
    # @example Remove the first character from a query string
    #   strip_first_character!("?foo=bar&baz=qux") #=> "foo=bar&baz=qux"
    def strip_first_character!(string)
      string[0] = ""
      string
    end

    # Converts query string to a hash
    #
    # @param query_string [String] The query string of a URL.
    # @return [Hash] The query string converted to a hash (with symbol keys).
    # @example Convert query string to a hash
    #   query_string_to_hash("foo=bar&baz=qux") #=> {:foo=>"bar", :baz=>"qux"}
    def query_string_to_hash(query_string)
      symbolize_keys(Faraday::Utils.parse_nested_query(query_string))
    end

    # Converts hash's keys to symbols
    #
    # @note Does not support nested hashes.
    # @param hash [Hash]
    # @return [Hash] The hash with symbols as keys.
    # @example Convert hash's keys to symbols
    #   symbolize_keys({"foo"=>"bar", "baz"=>"qux"}) #=> {:foo=>"bar", :baz=>"qux"}
    def symbolize_keys(hash)
      Hash[hash.map{|key, value| [key.to_sym, value]}]
    end

  end
end

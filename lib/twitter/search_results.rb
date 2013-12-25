require 'twitter/enumerable'

module Twitter
  class SearchResults
    include Twitter::Enumerable
    attr_reader :attrs
    alias_method :to_h, :attrs
    alias_method :to_hash, :attrs
    alias_method :to_hsh, :attrs

    class << self
      # Construct a new SearchResults object from a response hash
      #
      # @param response [Hash]
      # @param client [Twitter::REST::Client]
      # @param path [String]
      # @return [Twitter::SearchResults]
      def from_response(response, client, request_method, path, options) # rubocop:disable ParameterLists
        new(response[:body], client, request_method, path, options)
      end
    end

    # Initializes a new SearchResults object
    #
    # @param attrs [Hash]
    # @param client [Twitter::REST::Client]
    # @param request_method [String, Symbol]
    # @param path [String]
    # @param options [Hash]
    # @return [Twitter::SearchResults]
    def initialize(attrs, client, request_method, path, options = {}) # rubocop:disable ParameterLists
      @client = client
      @request_method = request_method.to_sym
      @path = path
      @options = options
      @collection = []
      self.attrs = attrs
    end

  private

    # @return [Boolean]
    def last?
      !next_results?
    end

    # @return [Boolean]
    def next_results?
      !!(@attrs[:search_metadata] && @attrs[:search_metadata][:next_results])
    end
    alias_method :next_page?, :next_results?
    alias_method :next?, :next_results?

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
    alias_method :next_page, :next_results
    alias_method :next, :next_results

    def fetch_next_page
      response = @client.send(@request_method, @path, next_page)
      self.attrs = response[:body]
    end

    def attrs=(attrs)
      @attrs = attrs
      Array(@attrs[:statuses]).map do |tweet|
        @collection << Tweet.new(tweet)
      end
    end

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
      string[0] = ''
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
      Hash[hash.map { |key, value| [key.to_sym, value] }]
    end
  end
end

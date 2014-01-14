require 'twitter/enumerable'
require 'twitter/utils'

module Twitter
  class SearchResults
    include Twitter::Enumerable
    include Twitter::Utils
    attr_reader :attrs
    alias_method :to_h, :attrs
    deprecate_alias :to_hash, :to_h
    deprecate_alias :to_hsh, :to_h

    class << self
      # Construct a new SearchResults object from a response hash
      #
      # @param response [Hash]
      # @param request [Twitter::Request]
      # @return [Twitter::SearchResults]
      def from_response(response, request)
        new(response[:body], request)
      end
    end

    # Initializes a new SearchResults object
    #
    # @param attrs [Hash]
    # @param request [Twitter::Request]
    # @return [Twitter::SearchResults]
    def initialize(attrs, request)
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = request.options
      @collection = []
      self.attrs = attrs
    end

  private

    # @return [Boolean]
    def last?
      !next_page?
    end

    # @return [Boolean]
    def next_page?
      !!@attrs[:search_metadata][:next_results] unless @attrs[:search_metadata].nil?
    end

    # Returns a Hash of query parameters for the next result in the search
    #
    # @note Returned Hash can be merged into the previous search options list to easily access the next page.
    # @return [Hash] The parameters needed to fetch the next page.
    def next_page
      if next_page?
        query_string = strip_first_character(@attrs[:search_metadata][:next_results])
        query_string_to_hash(query_string)
      end
    end

    def fetch_next_page
      response = @client.send(@request_method, @path, next_page)
      self.attrs = response[:body]
    end

    def attrs=(attrs)
      @attrs = attrs
      Array(@attrs[:statuses]).collect do |tweet|
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
      Hash[hash.collect { |key, value| [key.to_sym, value] }]
    end
  end
end

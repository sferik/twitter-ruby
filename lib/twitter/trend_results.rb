require 'twitter/creatable'
require 'twitter/null_object'

module Twitter
  class TrendResults
    include Enumerable
    include Twitter::Creatable
    attr_reader :attrs
    alias to_h attrs
    alias to_hash attrs
    alias to_hsh attrs

    # Construct a new SearchResults object from a response hash
    #
    # @param response [Hash]
    # @return [Twitter::Base]
    def self.from_response(response={})
      new(response[:body].first)
    end

    # Initializes a new SearchResults object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={})
      @attrs = attrs
      @collection = Array(@attrs[:trends]).map do |trend|
        Twitter::Trend.new(trend)
      end
    end

    # @return [Enumerator]
    def each(start = 0, &block)
      return to_enum(:each) unless block_given?
      Array(@collection[start..-1]).each do |element|
        yield element
      end
      self
    end

    # Time when the object was created on Twitter
    #
    # @return [Time]
    def as_of
      @as_of ||= Time.parse(@attrs[:as_of]) unless @attrs[:as_of].nil?
    end

    def location
      @location ||= if location?
        Twitter::Place.new(@attrs[:locations].first)
      else
        Twitter::NullObject.new
      end
    end

    def location?
      !@attrs[:locations].nil? && !@attrs[:locations].first.nil?
    end

  end
end

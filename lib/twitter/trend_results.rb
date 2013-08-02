require 'twitter/creatable'
require 'twitter/enumerable'
require 'twitter/null_object'

module Twitter
  class TrendResults
    include Twitter::Creatable
    include Twitter::Enumerable
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
    # @return [Twitter::TrendResults]
    def initialize(attrs={})
      @attrs = attrs
      @collection = Array(@attrs[:trends]).map do |trend|
        Twitter::Trend.new(trend)
      end
    end

    # Time when the object was created on Twitter
    #
    # @return [Time]
    def as_of
      @as_of ||= Time.parse(@attrs[:as_of]) if @attrs[:as_of]
    end

    def as_of?
      !!@attrs[:as_of]
    end

    # @return [Twitter::Place, NullObject]
    def location
      @location ||= if location?
        Twitter::Place.new(@attrs[:locations].first)
      else
        Twitter::NullObject.instance
      end
    end

    # @return [Boolean]
    def location?
      !@attrs[:locations].nil? && !@attrs[:locations].first.nil?
    end

  end
end

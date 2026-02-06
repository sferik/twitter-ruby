require "memoizable"
require "twitter/creatable"
require "twitter/enumerable"
require "twitter/null_object"
require "twitter/utils"

module Twitter
  # Represents a collection of trending topics
  class TrendResults
    include Creatable
    include Enumerable
    include Utils
    include Memoizable

    # The raw attributes hash
    #
    # @api public
    # @example
    #   results.attrs
    # @return [Hash]
    attr_reader :attrs

    # @!method to_h
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_h
    #   @return [Hash]
    alias to_h attrs

    # @!method to_hash
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_hash
    #   @return [Hash]
    alias to_hash to_h

    # Initializes a new TrendResults object
    #
    # @api public
    # @example
    #   Twitter::TrendResults.new(trends: [])
    # @param attrs [Hash] The attributes hash
    # @return [Twitter::TrendResults]
    def initialize(attrs = {})
      @attrs = attrs
      @collection = @attrs.fetch(:trends, []).collect do |trend|
        Trend.new(trend)
      end
    end

    # Returns the time when trends were retrieved
    #
    # @api public
    # @example
    #   results.as_of
    # @return [Time]
    def as_of
      Time.parse(@attrs[:as_of]).utc unless @attrs[:as_of].nil?
    end
    memoize :as_of

    # Returns true if as_of is available
    #
    # @api public
    # @example
    #   results.as_of?
    # @return [Boolean]
    def as_of?
      !!@attrs[:as_of]
    end
    memoize :as_of?

    # Returns the location for these trends
    #
    # @api public
    # @example
    #   results.location
    # @return [Twitter::Place, NullObject]
    def location
      location? ? Place.new(@attrs[:locations].first) : NullObject.new
    end
    memoize :location

    # Returns true if location is available
    #
    # @api public
    # @example
    #   results.location?
    # @return [Boolean]
    def location?
      !@attrs[:locations].nil? && !@attrs[:locations].first.nil?
    end
    memoize :location?
  end
end

require "memoizable"
require "X/creatable"
require "X/enumerable"
require "X/null_object"
require "X/utils"

module X
  class TrendResults
    include X::Creatable
    include X::Enumerable
    include X::Utils
    include Memoizable
    # @return [Hash]
    attr_reader :attrs
    alias to_h attrs
    alias to_hash to_h

    # Initializes a new TrendResults object
    #
    # @param attrs [Hash]
    # @return [X::TrendResults]
    def initialize(attrs = {})
      @attrs = attrs
      @collection = @attrs.fetch(:trends, []).collect do |trend|
        Trend.new(trend)
      end
    end

    # Time when the object was created on X
    #
    # @return [Time]
    def as_of
      Time.parse(@attrs[:as_of]).utc unless @attrs[:as_of].nil?
    end
    memoize :as_of

    def as_of?
      !!@attrs[:as_of]
    end
    memoize :as_of?

    # @return [X::Place, NullObject]
    def location
      location? ? Place.new(@attrs[:locations].first) : NullObject.new
    end
    memoize :location

    # @return [Boolean]
    def location?
      !@attrs[:locations].nil? && !@attrs[:locations].first.nil?
    end
    memoize :location?
  end
end

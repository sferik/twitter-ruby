require 'memoizable'
require 'twitter/creatable'
require 'twitter/enumerable'
require 'twitter/null_object'
require 'twitter/utils'

module Twitter
  class TrendResults
    include Twitter::Creatable
    include Twitter::Enumerable
    include Twitter::Utils
    include Memoizable
    attr_reader :attrs
    alias_method :to_h, :attrs
    deprecate_alias :to_hash, :to_h
    deprecate_alias :to_hsh, :to_h

    # Initializes a new TrendResults object
    #
    # @param attrs [Hash]
    # @return [Twitter::TrendResults]

    def attributes
        @attrs
    end

    def attr
        @attrs
    end

    
    def initialize(attrs = {})
      @attrs = attrs
      @collection = Array(@attrs[:trends]).collect do |trend|
        Trend.new(trend)
      end
    end

    # Time when the object was created on Twitter
    #
    # @return [Time]
    def as_of
      Time.parse(@attrs[:as_of]) unless @attrs[:as_of].nil?
    end
    memoize :as_of

    def as_of?
      !!@attrs[:as_of]
    end
    memoize :as_of?

    # @return [Twitter::Place, NullObject]
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

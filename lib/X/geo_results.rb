require "X/enumerable"
require "X/utils"

module X
  class GeoResults
    include X::Enumerable
    include X::Utils
    # @return [Hash]
    attr_reader :attrs
    alias to_h attrs
    alias to_hash to_h

    # Initializes a new GeoResults object
    #
    # @param attrs [Hash]
    # @return [X::GeoResults]
    def initialize(attrs = {})
      @attrs = attrs
      @collection = @attrs[:result].fetch(:places, []).collect do |place|
        Place.new(place)
      end
    end

    # @return [String]
    def token
      @attrs[:token]
    end
  end
end

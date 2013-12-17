require 'equalizer'
require 'twitter/base'

module Twitter
  class Identity < Twitter::Base
    include Equalizer.new(:id)
    attr_reader :id

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing an :id key.
    # @return [Twitter::Identity]
    def initialize(attrs = {})
      attrs.fetch(:id)
      super
    end

    # Serializes an object
    #
    # @return [String]
    def marshal_dump
      to_hash
    end

    # Converts serialized data into an object
    #
    # @param attrs [Hash]
    # @return [Twitter::Identity]
    def marshal_load(attrs = {})
      initialize(attrs)
    end
  end
end

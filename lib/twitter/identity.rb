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
    def initialize(attrs={})
      super
      raise ArgumentError, "argument must have an :id key" unless id
    end

  end
end

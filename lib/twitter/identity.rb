require "equalizer"
require "twitter/base"

module Twitter
  # Base class for Twitter objects with an identity
  class Identity < Twitter::Base
    include Equalizer.new(:id)

    # The unique identifier for this object
    #
    # @api public
    # @example
    #   tweet.id
    # @return [Integer]
    attr_reader :id

    # Initializes a new object
    #
    # @api public
    # @example
    #   Twitter::Identity.new(id: 123)
    # @param attrs [Hash] The attributes hash
    # @raise [ArgumentError] Error raised when argument is missing an :id key
    # @return [Twitter::Identity]
    def initialize(attrs = {})
      attrs.fetch(:id)
      super
    end
  end
end

require "time"
require "memoizable"

module Twitter
  # Provides created_at functionality for Twitter objects
  module Creatable
    include Memoizable

    # Time when the object was created on Twitter
    #
    # @api public
    # @example
    #   tweet.created_at # => 2025-01-15 12:00:00 UTC
    # @return [Time]
    def created_at
      time = @attrs[:created_at] # steep:ignore FallbackAny
      return if time.nil?

      time = Time.parse(time) unless time.is_a?(Time)
      time.utc
    end
    memoize :created_at

    # Check if the created_at attribute is present
    #
    # @api public
    # @example
    #   tweet.created? # => true
    # @return [Boolean]
    def created?
      !!@attrs[:created_at] # steep:ignore FallbackAny
    end
    memoize :created?
  end
end

module Twitter
  # Provides version information for the Twitter gem
  #
  # @api public
  module Version
    class << self
      # The major version number
      #
      # @api private
      # @example
      #   Twitter::Version.major # => 8
      # @return [Integer]
      def major
        8
      end

      # The minor version number
      #
      # @api private
      # @example
      #   Twitter::Version.minor # => 3
      # @return [Integer]
      def minor
        3
      end

      # The patch version number
      #
      # @api private
      # @example
      #   Twitter::Version.patch # => 1
      # @return [Integer]
      def patch
        1
      end

      # The pre-release version identifier
      #
      # @api private
      # @example
      #   Twitter::Version.pre # => nil
      # @return [Integer, NilClass]
      def pre
      end

      # The version as a hash
      #
      # @api private
      # @example
      #   Twitter::Version.to_h # => {major: 8, minor: 3, patch: 1, pre: nil}
      # @return [Hash]
      def to_h
        {major:, minor:, patch:, pre: nil}
      end

      # The version as an array
      #
      # @api private
      # @example
      #   Twitter::Version.to_a # => [8, 3, 1]
      # @return [Array]
      def to_a
        [major, minor, patch]
      end

      # The version as a string
      #
      # @api private
      # @example
      #   Twitter::Version.to_s # => "8.3.1"
      # @return [String]
      def to_s
        to_a.join(".")
      end
    end
  end
end

module Twitter
  # Provides version information for the Twitter gem
  #
  # @api public
  module Version
  module_function

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
    #   Twitter::Version.minor # => 2
    # @return [Integer]
    def minor
      2
    end

    # The patch version number
    #
    # @api private
    # @example
    #   Twitter::Version.patch # => 0
    # @return [Integer]
    def patch
      0
    end

    # The pre-release version identifier
    #
    # @api private
    # @example
    #   Twitter::Version.pre # => nil
    # @return [Integer, NilClass]
    def pre
      nil
    end

    # The version as a hash
    #
    # @api private
    # @example
    #   Twitter::Version.to_h # => {major: 8, minor: 2, patch: 0, pre: nil}
    # @return [Hash]
    def to_h
      {major:, minor:, patch:, pre:}
    end

    # The version as an array
    #
    # @api private
    # @example
    #   Twitter::Version.to_a # => [8, 2, 0]
    # @return [Array]
    def to_a
      [major, minor, patch, pre].compact
    end

    # The version as a string
    #
    # @api private
    # @example
    #   Twitter::Version.to_s # => "8.2.0"
    # @return [String]
    def to_s
      to_a.join(".")
    end
  end
end

module Twitter
  module Version
  module_function

    # @return [Integer]
    def major
      8
    end

    # @return [Integer]
    def minor
      2
    end

    # @return [Integer]
    def patch
      0
    end

    # @return [Integer, NilClass]
    def pre
      nil
    end

    # @return [Hash]
    def to_h
      {major:, minor:, patch:, pre:}
    end

    # @return [Array]
    def to_a
      [major, minor, patch, pre].compact
    end

    # @return [String]
    def to_s
      to_a.join(".")
    end
  end
end

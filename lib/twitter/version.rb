module Twitter
  class Version
    class << self
      # @return [Integer]
      def major
        5
      end

      # @return [Integer]
      def minor
        14
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
        {
          :major => MAJOR,
          :minor => MINOR,
          :patch => PATCH,
          :pre => PRE,
        }
      end

      # @return [Array]
      def to_a
        to_h.values.compact
      end

      # @return [String]
      def to_s
        to_a.join('.')
      end
    end
  end
end

module Twitter
  class Version
    MAJOR = 5
    MINOR = 14
    PATCH = 0
    PRE = nil

    class << self
      # @return [Array]
      def to_h
        {
          major: MAJOR,
          minor: MINOR,
          patch: PATCH,
          pre: PRE,
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

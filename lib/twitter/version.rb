module Twitter
  class Version
    MAJOR = 5
    MINOR = 14
    PATCH = 0
    PRE = nil

    class << self
      # @return [Array]
      def to_a
        [MAJOR, MINOR, PATCH, PRE].compact
      end

      # @return [String]
      def to_s
        to_a.join('.')
      end
    end
  end
end

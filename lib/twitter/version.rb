module Twitter
  class Version
    class << self
      def major
        2
      end

      def minor
        0
      end

      def patch
        0
      end

      def pre
        nil
      end

      def to_s
        [major, minor, patch, pre].compact.join('.')
      end
    end
  end
end

module Twitter
  class Version
    MAJOR = 5
    MINOR = 0
    PATCH = 0
    PRE = "rc.1"

    class << self

      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end

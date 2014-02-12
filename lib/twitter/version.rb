module Twitter
  class Version
    MAJOR = 5
    MINOR = 7
    PATCH = 1
    PRE = nil

    class << self
      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end
    end
  end
end

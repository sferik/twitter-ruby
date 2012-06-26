module Twitter
  class Version
    MAJOR = 3 unless defined? MAJOR
    MINOR = 0 unless defined? MINOR
    PATCH = 0 unless defined? PATCH
    PRE = "rc.4" unless defined? PRE

    class << self

      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end

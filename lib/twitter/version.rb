module Twitter
  class Version
    MAJOR = 3 unless defined? MAJOR
    MINOR = 0 unless defined? MINOR
    PATCH = 2 unless defined? PATCH
    PRE = nil unless defined? PRE

    class << self

      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end

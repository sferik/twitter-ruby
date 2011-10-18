module Twitter
  class Version

    def self.major
      2
    end

    def self.minor
      0
    end

    def self.patch
      0
    end

    def self.pre
      nil
    end

    def self.to_s
      [major, minor, patch, pre].compact.join('.')
    end

  end
end

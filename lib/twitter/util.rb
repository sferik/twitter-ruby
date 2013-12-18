module Twitter
  module Util
    def self.threaded_map(enumerable)
      enumerable.map { |object|
        Thread.new { yield object }
      }.map(&:value)
    end
  end
end

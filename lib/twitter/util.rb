module Twitter
  module Util
    def self.threaded_map(enumerable)
      # Don't bother spawning a new thread if there's only one item
      if enumerable.count == 1
        enumerable.map { |object| yield object }
      else
        enumerable.map { |object| Thread.new { yield object } }.map(&:value)
      end
    end
  end
end

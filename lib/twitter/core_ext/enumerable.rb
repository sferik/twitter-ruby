module Enumerable

  def threaded_map
    threads = map do |object|
      Thread.new { yield object }
    end
    threads.map(&:value)
  end

end

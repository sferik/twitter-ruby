module Enumerable

  def threaded_map
    threads = []
    each do |object|
      threads << Thread.new{yield object}
    end
    threads.map(&:value)
  end

end

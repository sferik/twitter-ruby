module Enumerable

  def threaded_map
    threads = []
    Thread.abort_on_exception = true
    each do |object|
      threads << Thread.new{yield object}
    end
    Thread.abort_on_exception = false
    threads.map(&:value)
  end

end

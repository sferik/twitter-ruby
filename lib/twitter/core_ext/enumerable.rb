module Enumerable

  def threaded_map
    initial_abort_on_exception = Thread.abort_on_exception
    Thread.abort_on_exception ||= true
    threads = []
    each do |object|
      threads << Thread.new { yield object }
    end
    Thread.abort_on_exception = initial_abort_on_exception
    threads.map(&:value)
  end

end

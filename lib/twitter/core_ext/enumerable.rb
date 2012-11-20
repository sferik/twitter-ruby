module Enumerable

  def threaded_map
    abort_on_exception do
      threads = []
      each do |object|
        threads << Thread.new { yield object }
      end
      threads.map(&:value)
    end
  end

private

  def abort_on_exception
    initial_abort_on_exception = Thread.abort_on_exception
    Thread.abort_on_exception ||= true
    value = yield
    Thread.abort_on_exception = initial_abort_on_exception
    value
  end

end

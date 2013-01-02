require 'celluloid'

module Enumerable

  def pmap(&block)
    futures = map do |elem|
      Celluloid::Future.new(elem, &block)
    end
    futures.map(&:value)
  end

end

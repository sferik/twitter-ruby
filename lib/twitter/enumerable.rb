module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0, &block)
      return to_enum(:each) unless block_given?
      for element in Array(@collection[start..-1])
        yield element
      end
      self
    end

  end
end

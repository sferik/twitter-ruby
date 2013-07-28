module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0, &block)
      return to_enum(:each) unless block_given?
      Array(@collection[start..-1]).each do |element|
        yield element
      end
      self
    end

  end
end

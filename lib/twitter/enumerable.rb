module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0)
      return to_enum(:each, start) unless block_given?
      Array(@collection[start..-1]).each do |element|
        yield(element)
      end
      unless last? || reached_limit?
        start = [@collection.size, start].max
        fetch_next_page
        each(start, &Proc.new)
      end
      self
    end

    def map(&block)
      result = []
      each { |element| result << block.call(element) }
      result
    end

  private

    # @return [Boolean]
    def last?
      true
    end

    def reached_limit?
      false
    end
  end
end

module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0)
      return to_enum(:each, start) unless block_given?
      each_page(start) do |elements|
        elements.each { |element| yield element }
      end
      self
    end

    # @return [Enumerator]
    def each_page(start = 0)
      return to_enum(:each_page, start) unless block_given?
      yield Array(@collection[start..-1])
      unless last?
        start = [@collection.size, start].max
        fetch_next_page
        each_page(start, &Proc.new)
      end
      self
    end

  private

    # @return [Boolean]
    def last?
      true
    end
  end
end

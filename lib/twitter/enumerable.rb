module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0, &block)
      return to_enum(:each, start) unless block

      Array(@collection[start..]).each(&block)
      unless finished?
        start = [@collection.size, start].max
        fetch_next_page
        each(start, &block)
      end
      self
    end

  private

    # @return [Boolean]
    def last?
      true
    end

    # @return [Boolean]
    def reached_limit?
      false
    end

    # @return [Boolean]
    def finished?
      last? || reached_limit?
    end
  end
end

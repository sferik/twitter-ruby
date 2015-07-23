module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0)
      return to_enum(:each, start) unless block_given?
      Array(@collection[start..-1]).each do |element|
        yield(element)
      end
      unless last?
        start = [@collection.size, start].max
        begin
          fetch_next_page
          each(start, &Proc.new)
        rescue Twitter::Error::TooManyRequests => error
          sleep error.rate_limit.reset_in + 1
          retry
        end
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

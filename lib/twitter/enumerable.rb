module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0)
      @page_record ||= 0
      return to_enum(:each, start) unless block_given?
      slice_index = @page_record >= start ? 0 : start - @page_record
      Array(@collection[slice_index..-1]).each do |element|
        yield(element)
      end
      unless last?
        @page_record += @collection.size
        @collection = []
        fetch_next_page
        each(start, &Proc.new)
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

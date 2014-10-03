module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0)
      pp start
      pp @page_record
      return to_enum(:each, start) unless block_given?
      slice_index = @page_record >= start ? 0 : start - @page_record
      # pp slice_index
      # pp @page_record
      # pp @collection
      Array(@collection[slice_index..-1]).each do |element|
        yield(element)
      end
      unless last?
        # start = [@page_record, start].max
        # start = [@collection.size, start].max
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

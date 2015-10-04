module Twitter
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0)
      return to_enum(:each, start) unless block_given?
      slice_index = get_slice_index(start)
      Array(@collection[slice_index..-1]).each do |element|
        yield(element)
      end
      unless last?
        blank_cached_tweets_and_fill_from_next_page
        each(start, &Proc.new)
      end
      self
    end

  private

    def get_slice_index(start)
      @page_record ||= 0
      @page_record >= start ? 0 : start - @page_record
    end

    def blank_cached_tweets_and_fill_from_next_page
      @page_record += @collection.size
      @collection = []
      fetch_next_page
    end

    # @return [Boolean]
    def last?
      true
    end
  end
end

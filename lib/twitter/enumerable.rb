module Twitter
  # Provides iteration support for collections
  module Enumerable
    include ::Enumerable

    # Iterates over the collection
    #
    # @api public
    # @example
    #   cursor.each { |item| puts item }
    # @param start [Integer] The starting index
    # @yield [Object] Each item in the collection
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

    # Returns true if this is the last page
    #
    # @api private
    # @return [Boolean]
    def last?
      true
    end

    # Returns true if the limit has been reached
    #
    # @api private
    # @return [Boolean]
    def reached_limit?
      false
    end

    # Returns true if iteration is finished
    #
    # @api private
    # @return [Boolean]
    def finished?
      last? || reached_limit?
    end
  end
end

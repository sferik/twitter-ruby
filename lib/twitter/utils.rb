module Twitter
  # Utility methods for parallel mapping
  #
  # @api private
  module Utils
  module_function

    # Parallel flat_map for enumerables
    #
    # @api private
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def flat_pmap(enumerable, &block)
      return to_enum(:flat_pmap, enumerable) unless block

      pmap(enumerable, &block).flatten(1)
    end

    # Parallel map for enumerables
    #
    # @api private
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def pmap(enumerable, &block)
      return to_enum(:pmap, enumerable) unless block

      if enumerable.one?
        enumerable.collect(&block)
      else
        enumerable.collect { |object| Thread.new { yield(object) } }.collect(&:value)
      end
    end
  end
end

module Twitter
  # Utility methods for parallel mapping
  #
  # @api private
  module Utils
    # Parallel flat_map for enumerables
    #
    # @api private
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def flat_pmap(enumerable, &block)
      return to_enum(:flat_pmap, enumerable) unless block

      pmap(enumerable, &block).flatten(1)
    end
    module_function :flat_pmap

    # Parallel map for enumerables
    #
    # @api private
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def pmap(enumerable)
      return to_enum(__method__, enumerable) unless block_given?

      enumerable.collect { |object| yield(object) }
    end
    module_function :pmap
  end
end

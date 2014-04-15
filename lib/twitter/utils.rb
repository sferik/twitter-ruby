module Twitter
  module Utils
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def deprecate_alias(new_name, old_name)
        define_method(new_name) do |*args|
          warn "#{Kernel.caller.first}: [DEPRECATION] ##{new_name} is deprecated. Use ##{old_name} instead."
          if block_given?
            send(old_name, *args, &Proc.new)
          else
            send(old_name, *args)
          end
        end
      end
    end

    # Returns a new array with the concatenated results of running block once for every element in enumerable.
    # If no block is given, an enumerator is returned instead.
    #
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def flat_pmap(enumerable)
      if block_given?
        pmap(enumerable, &Proc.new).flatten(1)
      else
        to_enum(:flat_pmap, enumerable)
      end
    end
    module_function :flat_pmap

    # Returns a new array with the results of running block once for every element in enumerable.
    # If no block is given, an enumerator is returned instead.
    #
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def pmap(enumerable)
      return to_enum(:pmap, enumerable) unless block_given?
      pmap_with_index(enumerable).sort_by { |_, index| index }.collect { |object, _| yield(object) }
    end
    module_function :pmap

    # Calls block with two arguments, the item and its index, for each item in enumerable. Given arguments are passed through to pmap.
    # If no block is given, an enumerator is returned instead.
    #
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def pmap_with_index(enumerable)
      return to_enum(:pmap_with_index, enumerable) unless block_given?
      # Don't bother spawning a new thread if there's only one item
      if enumerable.count == 1
        enumerable.collect { |object| yield(object, 0) }
      else
        enumerable.each_with_index.collect { |object, index| Thread.new { yield(object, index) } }.collect(&:value)
      end
    end
    module_function :pmap_with_index
  end
end

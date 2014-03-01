module Twitter
  module Utils
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def deprecate_alias(new_name, old_name)
        define_method(new_name) do |*args, &block|
          warn "#{Kernel.caller.first}: [DEPRECATION] ##{new_name} is deprecated. Use ##{old_name} instead."
          send(old_name, *args, &block)
        end
      end
    end

    # Returns a new array with the results of running block once for every element in enumerable.
    # If no block is given, an enumerator is returned instead.
    #
    # @param enumerable [Enumerable]
    # @return [Array, Enumerator]
    def pmap(enumerable)
      return to_enum(:pmap, enumerable) unless block_given?
      # Don't bother spawning a new thread if there's only one item
      if enumerable.count == 1
        enumerable.collect { |object| yield object }
      else
        enumerable.collect { |object| Thread.new { yield object } }.collect(&:value)
      end
    end
    module_function :pmap
  end
end

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

    def parallel_map(enumerable)
      # Don't bother spawning a new thread if there's only one item
      if enumerable.count == 1
        enumerable.collect { |object| yield object }
      else
        enumerable.collect { |object| Thread.new { yield object } }.collect(&:value)
      end
    end
    module_function :parallel_map
  end
end

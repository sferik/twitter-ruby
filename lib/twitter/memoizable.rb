require 'thread_safe'

module Twitter

  Memory = Class.new(ThreadSafe::Cache)

  module Memoizable

    class << self

      def included(base)
        base.extend(ClassMethods)
      end

    end

    module ClassMethods

      # Memoize a list of methods
      #
      # @example
      #   memoize :hash
      #
      # @param [Array<#to_s>] methods
      #   a list of methods to memoize
      def memoize(*methods)
        for method in methods
          memoize_method(method)
        end
      end

    private

      # Memoize the named method
      #
      # @param [#to_s] method_name
      #   a method name to memoize
      def memoize_method(method_name)
        method = instance_method(method_name)
        raise ArgumentError, 'Cannot memoize method with nonzero arity' if method.arity > 0
        memoized_methods[method_name] = method
        visibility = method_visibility(method_name)
        define_memoize_method(method)
        send(visibility, method_name)
      end

      # Return original method registry
      #
      # @return [Hash<Symbol, UnboundMethod>]
      def memoized_methods
        @memoized_methods ||= ThreadSafe::Cache.new do |_, name|
          raise ArgumentError, "No method #{name.inspect} was memoized"
        end
      end

      # Return the method visibility of a method
      #
      # @param [String, Symbol] method
      #   the name of the method
      #
      # @return [Symbol]
      def method_visibility(method)
        if private_method_defined?(method)
          :private
        elsif protected_method_defined?(method)
          :protected
        else
          :public
        end
      end

      # Define a memoized method that delegates to the original method
      #
      # @param [UnboundMethod] method
      #   the method to memoize
      def define_memoize_method(method)
        method_name = method.name.to_sym
        undef_method(method_name)
        define_method(method_name) do
          memory.fetch(method_name) do
            memory[method_name] ||= method.bind(self).call
          end
        end
      end

    end

  private

    # The memoized method results
    #
    # @return [Hash]
    def memory
      @__memory ||= Memory.new
    end

  end
end

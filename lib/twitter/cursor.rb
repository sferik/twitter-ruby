require 'active_support/core_ext/kernel/singleton_class'
require 'twitter/base'

module Twitter
  class Cursor < Twitter::Base
    attr_reader :collection
    lazy_attr_reader :next_cursor, :previous_cursor
    alias :next :next_cursor
    alias :previous :previous_cursor

    # Initializes a new Cursor object
    #
    # @param attrs [Hash]
    # @params method [String, Symbol] The name of the method to return the collection
    # @params klass [Class] The class to instantiate object in the collection
    # @return [Twitter::Cursor]
    def initialize(attrs, method, klass=nil)
      super(attrs)
      @collection = Array(attrs[method.to_s]).map do |item|
        if klass
          klass.new(item)
        else
          item
        end
      end
      singleton_class.class_eval do
        alias_method method.to_sym, :collection
      end
    end

    # @return [Boolean]
    def first?
      previous_cursor.zero?
    end
    alias :first :first?

    # @return [Boolean]
    def last?
      next_cursor.zero?
    end
    alias :last :last?

  end
end

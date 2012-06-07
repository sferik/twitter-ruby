require 'twitter/core_ext/kernel'

module Twitter
  class Cursor
    attr_reader :collection
    attr_accessor :attrs
    alias :to_hash :attrs

    # Initializes a new Cursor object
    #
    # @param attrs [Hash]
    # @params method [String, Symbol] The name of the method to return the collection
    # @params klass [Class] The class to instantiate object in the collection
    # @return [Twitter::Cursor]
    def initialize(attrs, method, klass=nil)
      @attrs = attrs
      @collection = Array(attrs[method.to_s]).map do |item|
        if klass
          klass.get_or_new(item)
        else
          item
        end
      end
      class_eval do
        alias_method method.to_sym, :collection
      end
    end

    def next_cursor
      @attrs['next_cursor']
    end
    alias :next :next_cursor

    def previous_cursor
      @attrs['previous_cursor']
    end
    alias :previous :previous_cursor

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

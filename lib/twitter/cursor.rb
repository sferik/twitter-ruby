require 'active_support/core_ext/kernel/singleton_class'
require 'twitter/base'

module Twitter
  class Cursor < Twitter::Base
    attr_reader :collection, :next_cursor, :previous_cursor
    alias :next :next_cursor
    alias :previous :previous_cursor

    def initialize(cursor, method, klass=nil)
      @collection = cursor[method.to_s].map do |item|
        if klass
          klass.new(item)
        else
          item
        end
      end unless cursor[method.to_s].nil?
      @next_cursor = cursor['next_cursor']
      @previous_cursor = cursor['previous_cursor']
      singleton_class.class_eval do
        alias_method method.to_sym, :collection
      end
    end

    def first?
      @previous_cursor.zero?
    end
    alias :first :first?

    def last?
      @next_cursor.zero?
    end
    alias :last :last?
  end
end

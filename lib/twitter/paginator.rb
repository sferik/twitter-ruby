require 'twitter/base'

module Twitter
  class Paginator < Twitter::Base
    attr_reader :next_cursor, :previous_cursor

    def initialize(object, method, klass=nil)
      @previous_cursor = object['previous_cursor']
      @next_cursor = object['next_cursor']
      (class << self; self; end).class_eval do
        define_method method.to_sym do
          @collection ||= object[method.to_s].map do |item|
            if klass
              klass.new(item)
            else
              item
            end
          end
        end
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

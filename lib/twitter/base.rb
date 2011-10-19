module Twitter
  class Base
    attr_accessor :attrs
    alias :to_hash :attrs

    def self.lazy_attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method attribute do
            instance_variable_get("@attrs")[attribute.to_s]
          end
        end
      end
    end

    def initialize(attrs = {})
      @attrs = attrs.dup
    end

    def [](method)
      self.__send__(method.to_sym)
    end

  end
end

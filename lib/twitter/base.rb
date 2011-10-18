module Twitter
  class Base
    attr_accessor :attributes
    alias :to_hash :attributes

    def self.lazy_attr_reader(*attributes)
      attributes.each do |attribute|
        class_eval do
          define_method attribute do
            instance_variable_get("@attributes")[attribute.to_s]
          end
        end
      end
    end

    def initialize(attributes = {})
      @attributes = attributes.dup
    end

    def [](method)
      self.__send__(method.to_sym)
    end

  end
end

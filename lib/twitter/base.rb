module Twitter
  class Base

    def self.lazy_attr_reader(*attributes)
      attributes.each do |attribute|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{attribute}
            @#{attribute} ||= @attributes[#{attribute.to_s.inspect}]
          end
        RUBY
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

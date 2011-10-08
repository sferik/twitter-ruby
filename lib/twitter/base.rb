module Twitter
  class Base

    def initialize(hash={})
      hash.each do |key, value|
        instance_variable_set(:"@#{key}", value) unless value.nil?
      end
      self
    end

  end
end

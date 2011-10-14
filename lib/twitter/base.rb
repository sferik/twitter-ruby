module Twitter
  class Base
    def initialize(hash={})
      hash.each do |key, value|
        instance_variable_set(:"@#{key}", value) unless value.nil?
      end
    end

    def to_hash
      Hash[instance_variables.map{|ivar| [ivar[1..-1].to_sym, instance_variable_get(ivar)]}]
    end
  end
end

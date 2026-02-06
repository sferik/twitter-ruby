module Twitter
  # Factory for creating Twitter objects based on type
  class Factory
    class << self
      # Constructs a new object based on type
      #
      # @api public
      # @example
      #   Twitter::Factory.new(:type, Twitter::Geo, attrs)
      # @param method [Symbol] The key to look up the type
      # @param klass [Class] The base class for the type
      # @param attrs [Hash] The attributes hash
      # @raise [IndexError] Error raised when argument is missing a key
      # @return [Twitter::Base]
      def new(method, klass, attrs = {})
        type = attrs.fetch(method.to_sym)
        const_name = type.split("_").collect(&:capitalize).join
        klass.const_get(const_name.to_sym).new(attrs)
      end
    end
  end
end

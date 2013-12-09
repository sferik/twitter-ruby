module Twitter
  class Factory
    class << self
      # Construct a new object
      #
      # @param method [Symbol]
      # @param klass [Class]
      # @param attrs [Hash]
      # @raise [IndexError] Error raised when supplied argument is missing a key.
      # @return [Twitter::Base]
      def new(method, klass, attrs = {})
        type = attrs.fetch(method.to_sym)
        const_name = type.gsub(/\/(.?)/) { "::#{Regexp.last_match[1].upcase}" }.gsub(/(?:^|_)(.)/) { Regexp.last_match[1].upcase }
        klass.const_get(const_name.to_sym).new(attrs)
      end
    end
  end
end

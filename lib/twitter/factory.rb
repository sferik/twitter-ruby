module Twitter
  class Factory

    def self.new(method, klass, attrs={})
      type = attrs.delete(method.to_sym)
      if type
        const_name = type.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
        klass.const_get(const_name.to_sym).new(attrs)
      else
        raise ArgumentError, "argument must have :#{method} key"
      end
    end

  end
end

module Twitter
  class Base
    def client(options={})
      Twitter::Client.new(options)
    end

    def method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      warn "#{Kernel.caller.first}: [DEPRECATION] Twitter::Base##{method} is deprecated and will be permanently removed in the next major version. Please use Twitter::Client##{method} instead."
      client.send(method, *args, &block)
    end
  end
end

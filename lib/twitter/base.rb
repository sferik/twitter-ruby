require 'twitter/client'

module Twitter
  # @deprecated {Twitter::Base} is deprecated and will be permanently removed in the next major version. Please use {Twitter::Client} instead.
  class Base
    # Alias for Twitter::Client.new
    #
    # @deprecated {Twitter::Base} is deprecated and will be permanently removed in the next major version. Please use {Twitter::Client} instead.
    # @return [Twitter::Client]
    def client(options={})
      warn "#{Kernel.caller.first}: [DEPRECATION] Twitter::Base is deprecated and will be permanently removed in the next major version. Please use Twitter::Client instead."
      Twitter::Client.new(options)
    end

    # Delegate to Twitter::Client
    #
    # @deprecated {Twitter::Base} is deprecated and will be permanently removed in the next major version. Please use {Twitter::Client} instead.
    def method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      warn "#{Kernel.caller.first}: [DEPRECATION] Twitter::Base##{method} is deprecated and will be permanently removed in the next major version. Please use Twitter::Client##{method} instead."
      Twitter::Client.new.send(method, *args, &block)
    end
  end
end

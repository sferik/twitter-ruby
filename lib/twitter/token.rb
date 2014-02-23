require 'twitter/base'

module Twitter
  class Token < Twitter::Base
    attr_reader :access_token, :token_type
    alias_method :to_s, :access_token

    BEARER_TYPE = 'bearer'

    # @return [Boolean]

    def attributes
        @attrs
    end

    def attr
        @attrs
    end

    def access_token
   @attrs.access_token
end
def token_type
   @attrs.token_type
end
    
    def bearer?
      @attrs[:token_type] == BEARER_TYPE
    end
    memoize :bearer?
  end
end

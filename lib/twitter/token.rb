require 'twitter/base'

module Twitter
  class Token < Twitter::Base
    attr_reader :token_type, :access_token

    BEARER_TYPE = "bearer"

    # @return [Boolean]
    def bearer?
      @attrs[:token_type] == BEARER_TYPE
    end

  end
end

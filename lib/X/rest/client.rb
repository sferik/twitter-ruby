require "X/client"
require "X/rest/api"
require "X/rest/request"
require "X/rest/utils"

module X
  module REST
    class Client < X::Client
      include X::REST::API
      attr_accessor :bearer_token

      # @return [Boolean]
      def bearer_token?
        !!bearer_token
      end

      # @return [Boolean]
      def credentials?
        super || bearer_token?
      end
    end
  end
end

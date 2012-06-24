require 'faraday'
require 'twitter/error/bad_gateway'
require 'twitter/error/internal_server_error'
require 'twitter/error/service_unavailable'

module Twitter
  module Response
    class RaiseServerError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status].to_i
        error_class = Twitter::Error::ServerError.errors[status_code]
        raise error_class.new if error_class
      end

    end
  end
end

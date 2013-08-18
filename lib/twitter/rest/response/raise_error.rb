require 'faraday'
require 'twitter/error/bad_gateway'
require 'twitter/error/bad_request'
require 'twitter/error/forbidden'
require 'twitter/error/gateway_timeout'
require 'twitter/error/internal_server_error'
require 'twitter/error/not_acceptable'
require 'twitter/error/not_found'
require 'twitter/error/service_unavailable'
require 'twitter/error/too_many_requests'
require 'twitter/error/unauthorized'
require 'twitter/error/unprocessable_entity'

module Twitter
  module REST
    module Response
      class RaiseError < Faraday::Response::Middleware

        def on_complete(env)
          status_code = env[:status].to_i
          error_class = Twitter::Error.errors[status_code]
          raise error_class.from_response(env) if error_class
        end

      end
    end
  end
end

require 'faraday'
require 'twitter/error/bad_gateway'
require 'twitter/error/bad_request'
require 'twitter/error/forbidden'
require 'twitter/error/gateway_timeout'
require 'twitter/error/internal_server_error'
require 'twitter/error/not_acceptable'
require 'twitter/error/not_found'
require 'twitter/error/rate_limited'
require 'twitter/error/service_unavailable'
require 'twitter/error/unauthorized'

module Twitter
  module Response
    class RaiseError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status].to_i
        error_class = @klass.errors[status_code]
        raise error_class.from_response(env) if error_class
      end

      def initialize(app, klass)
        @klass = klass
        super(app)
      end

    end
  end
end

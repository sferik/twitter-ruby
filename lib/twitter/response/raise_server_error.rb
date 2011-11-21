require 'faraday'
require 'twitter/error/bad_gateway'
require 'twitter/error/internal_server_error'
require 'twitter/error/service_unavailable'

module Twitter
  module Response
    class RaiseServerError < Faraday::Response::Middleware

      def on_complete(env)
        case env[:status].to_i
        when 500
          raise Twitter::Error::InternalServerError.new("Something is technically wrong.", env[:response_headers])
        when 502
          raise Twitter::Error::BadGateway.new("Twitter is down or being upgraded.", env[:response_headers])
        when 503
          raise Twitter::Error::ServiceUnavailable.new("(__-){ Twitter is over capacity.", env[:response_headers])
        end
      end

    end
  end
end

require 'faraday'
require 'twitter/error/bad_gateway'
require 'twitter/error/internal_server_error'
require 'twitter/error/service_unavailable'

module Twitter
  module Response
    class RaiseHttp5xx < Faraday::Response::Middleware
      def on_complete(env)
        case env[:status].to_i
        when 500
          raise Twitter::Error::InternalServerError.new(error_message(env, "Something is technically wrong."), env[:response_headers])
        when 502
          raise Twitter::Error::BadGateway.new(error_message(env, "Twitter is down or being upgraded."), env[:response_headers])
        when 503
          raise Twitter::Error::ServiceUnavailable.new(error_message(env, "(__-){ Twitter is over capacity."), env[:response_headers])
        end
      end

    private

      def error_message(env, body=nil)
        "#{env[:method].to_s.upcase} #{env[:url].to_s}: #{[env[:status].to_s + ':', body].compact.join(' ')} Check http://status.twitter.com/ for updates on the status of the Twitter service."
      end
    end
  end
end

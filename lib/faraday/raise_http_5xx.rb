require 'faraday'

# @private
module Faraday
  # @private
  class Response::RaiseHttp5xx < Response::Middleware
    def on_complete(response)
      case response[:status].to_i
      when 500
        raise Twitter::InternalServerError.new(error_message(response, "Something is technically wrong."), response[:response_headers])
      when 502
        raise Twitter::BadGateway.new(error_message(response, "Twitter is down or being upgraded."), response[:response_headers])
      when 503
        raise Twitter::ServiceUnavailable.new(error_message(response, "(__-){ Twitter is over capacity."), response[:response_headers])
      end
    end

    private

    def error_message(response, body=nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')} Check http://status.twitter.com/ for updates on the status of the Twitter service."
    end
  end
end

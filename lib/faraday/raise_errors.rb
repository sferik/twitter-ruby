module Faraday
  class Response::RaiseErrors < Response::Middleware
    def self.register_on_complete(env)
      env[:response].on_complete do |response|
        case response[:status].to_i
        when 400
          raise Twitter::RateLimitExceeded, "#{response[:body]['error'] if response[:body]}"
        when 401
          raise Twitter::Unauthorized, "#{response[:body]['error'] if response[:body]}"
        when 403
          raise Twitter::General, "#{response[:body]['error'] if response[:body]}"
        when 404
          raise Twitter::NotFound, "#{response[:body]['error'] if response[:body]}"
        when 500
          raise Twitter::InformTwitter, "#{response[:body]['error'] if response[:body]}"
        when 502..503
          raise Twitter::Unavailable, "#{response[:body]['error'] if response[:body]}"
        end
      end
    end

    def initialize(app)
      super
      @parser = nil
    end
  end
end

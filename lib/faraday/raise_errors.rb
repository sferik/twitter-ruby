module Faraday
  class Response::RaiseErrors < Response::Middleware
    def self.register_on_complete(env)
      env[:response].on_complete do |response|
        case response[:status].to_i
        when 400
          raise Twitter::RateLimitExceeded, "(#{response[:status]}): #{response[:body]}"
        when 401
          raise Twitter::Unauthorized, "(#{response[:status]}): #{response[:body]}"
        when 403
          raise Twitter::General, "(#{response[:status]}): #{response[:body]}"
        when 404
          raise Twitter::NotFound, "(#{response[:status]}): #{response[:body]}"
        when 500
          raise Twitter::InformTwitter, "Twitter had an internal error. Please let them know in the group. (#{response[:status]}): #{response[:body]}"
        when 502..503
          raise Twitter::Unavailable, "(#{response[:status]}): #{response[:body]}"
        end
      end
    end

    def initialize(app)
      super
      @parser = nil
    end
  end
end

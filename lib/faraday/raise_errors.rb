module Faraday
  class Response::RaiseErrors < Response::Middleware
    def self.register_on_complete(env)
      env[:response].on_complete do |response|
        case response[:status].to_i
        when 400
          raise Twitter::BadRequest, "#{response[:body]['error'] if response[:body]}"
        when 401
          raise Twitter::Unauthorized, "#{response[:body]['error'] if response[:body]}"
        when 403
          raise Twitter::Forbidden, "#{response[:body]['error'] if response[:body]}"
        when 404
          raise Twitter::NotFound, "#{response[:body]['error'] if response[:body]}"
        when 406
          raise Twitter::NotAcceptable, "#{response[:body]['error'] if response[:body]}"
        when 420
          raise Twitter::EnhanceYourCalm, "#{response[:body]['error'] if response[:body]}"
        when 500
          raise Twitter::InternalServerError, "#{response[:body]['error'] if response[:body]}"
        when 502
          raise Twitter::BadGateway, "#{response[:body]['error'] if response[:body]}"
        when 503
          raise Twitter::ServiceUnavailable, "#{response[:body]['error'] if response[:body]}"
        end
      end
    end

    def initialize(app)
      super
      @parser = nil
    end
  end
end

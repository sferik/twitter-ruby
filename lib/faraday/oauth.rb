module Faraday
  class Request::OAuth < Faraday::Middleware
    def call(env)
      params = env[:body].is_a?(Hash) ? env[:body] : {}
      header = SimpleOAuth::Header.new(env[:method], env[:url], params, @options)

      env[:request_headers].merge!('Authorization' => header.to_s)

      @app.call(env)
    end

    def initialize(app, options)
      @app, @options = app, options
    end
  end
end

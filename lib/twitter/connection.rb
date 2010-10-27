require 'faraday_middleware'
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

module Twitter
  module Connection
    private

    def connection(raw=false)
      options = {
        :headers => {:user_agent => user_agent},
        :ssl => {:verify => false},
        :url => api_endpoint
      }

      Faraday::Connection.new(options) do |builder|
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::OAuth, authentication if authenticated?
        builder.adapter(adapter)
        builder.use Faraday::Response::RaiseHttp5xx
        builder.use Faraday::Response::Parse unless raw
        builder.use Faraday::Response::RaiseHttp4xx
        builder.use Faraday::Response::Mashify unless raw
      end
    end
  end
end

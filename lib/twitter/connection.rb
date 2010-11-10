require 'faraday_middleware'
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

module Twitter
  # @private
  module Connection
    private

    def connection(raw=false)
      options = {
        :headers => {'Accept' => "application/#{format}", 'User-Agent' => user_agent},
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => api_endpoint,
      }

      Faraday::Connection.new(options) do |connection|
        connection.use Faraday::Request::Multipart
        connection.use Faraday::Request::OAuth, authentication if authenticated?
        connection.adapter(adapter)
        connection.use Faraday::Response::RaiseHttp5xx
        unless raw
          case format.to_s.downcase
          when 'json' then connection.use Faraday::Response::ParseJson
          when 'xml' then connection.use Faraday::Response::ParseXml
          end
        end
        connection.use Faraday::Response::RaiseHttp4xx
        connection.use Faraday::Response::Mashify unless raw
      end
    end
  end
end

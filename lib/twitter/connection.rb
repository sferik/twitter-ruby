require 'twitter/request/gateway'
require 'twitter/request/multipart_with_file'
require 'twitter/request/phoenix'
require 'twitter/request/oauth'
require 'twitter/response/mashify'
require 'twitter/response/parse_json'
require 'twitter/response/raise_http_4xx'
require 'twitter/response/raise_http_5xx'

module Twitter
  module Connection
  private

    def connection(options={})
      merged_options = faraday_options.merge({
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => options.fetch(:endpoint, api_endpoint),
      })

      Faraday.new(merged_options) do |builder|
        builder.use Twitter::Request::Phoenix if options[:phoenix]
        builder.use Twitter::Request::MultipartWithFile
        builder.use Twitter::Request::TwitterOAuth, authentication if authenticated?
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Twitter::Request::Gateway, gateway if gateway
        builder.use Twitter::Response::RaiseHttp4xx
        unless options[:raw]
          builder.use Twitter::Response::Mashify
          builder.use Twitter::Response::ParseJson
        end
        builder.use Twitter::Response::RaiseHttp5xx
        builder.adapter(adapter)
      end
    end
  end
end

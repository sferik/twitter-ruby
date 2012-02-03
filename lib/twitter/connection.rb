require 'faraday'
require 'twitter/core_ext/hash'
require 'twitter/request/gateway'
require 'twitter/request/multipart_with_file'
require 'twitter/request/phoenix'
require 'twitter/request/oauth'
require 'twitter/response/parse_json'
require 'twitter/response/raise_client_error'
require 'twitter/response/raise_server_error'

module Twitter
  module Connection
  private

    # Returns a Faraday::Connection object
    #
    # @param options [Hash] A hash of options
    # @return [Faraday::Connection]
    def connection(options={})
      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => options.fetch(:endpoint, endpoint),
      }
      @connection ||=Faraday.new(default_options.deep_merge(connection_options)) do |builder|
        builder.use Twitter::Request::Phoenix
        builder.use Twitter::Request::MultipartWithFile
        builder.use Twitter::Request::TwitterOAuth, credentials if credentials?
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Twitter::Request::Gateway, gateway if gateway
        builder.use Twitter::Response::RaiseClientError
        builder.use Twitter::Response::ParseJson
        builder.use Twitter::Response::RaiseServerError
        builder.adapter(adapter)
      end
    end
  end
end

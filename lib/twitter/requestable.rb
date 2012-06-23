require 'faraday'
require 'simple_oauth'
require 'twitter/core_ext/hash'
require 'uri'

module Twitter
  # Defines HTTP request methods
  module Requestable

    # Perform an HTTP DELETE request
    def delete(path, params={}, options={})
      request(:delete, path, params, options)
    end

    # Perform an HTTP GET request
    def get(path, params={}, options={})
      request(:get, path, params, options)
    end

    # Perform an HTTP POST request
    def post(path, params={}, options={})
      request(:post, path, params, options)
    end

  private

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      return @connection if defined? @connection
      @connection = Faraday.new(endpoint, connection_options.merge(:builder => middleware))
    end

    # Perform an HTTP request
    def request(method, path, params, options)
      uri = options[:endpoint] || endpoint
      uri = URI(uri) unless uri.respond_to?(:host)
      uri += path
      request_headers = {}
      if credentials?
        # When posting a file, don't sign any params
        signature_params = if :post == method.to_sym && params.values.any?{|value| value.is_a?(File) || (value.is_a?(Hash) && (value['io'].is_a?(IO) || value['io'].is_a?(StringIO)))}
          {}
        else
          params
        end
        authorization = SimpleOAuth::Header.new(method, uri, signature_params, credentials)
        request_headers['Authorization'] = authorization.to_s
      end

      connection.url_prefix = options[:endpoint] || endpoint
      connection.run_request(method.to_sym, path, nil, request_headers) do |request|
        unless params.empty?
          if :post == request.method
            request.body = params
          else
            request.params.update params
          end
        end
        yield request if block_given?
      end.env
    rescue Faraday::Error::ClientError
      raise Twitter::Error::ClientError
    end

  end
end

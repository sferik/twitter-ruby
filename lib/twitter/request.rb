require 'uri'

module Twitter
  # Defines HTTP request methods
  module Request

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

    # Perform an HTTP request
    def request(method, path, params, options)
      if url = options[:endpoint]
        url = URI(url) unless url.respond_to? :host
        path = url + path
      end
      response = connection.run_request(method.to_sym, path, nil, nil) do |request|
        request.options[:raw] = true if options[:raw]
        unless params.empty?
          if :post == request.method
            request.body = params
          else
            request.params.update params
          end
        end
        yield request if block_given?
      end
      options[:raw] ? response : response.body
    end

  end
end

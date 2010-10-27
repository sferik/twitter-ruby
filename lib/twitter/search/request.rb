module Twitter
  class Search
    module Request
      def get(path, options={}, raw=false)
        request(:get, path, options, raw)
      end

      private

      def request(method, path, options, raw)
        response = connection(raw).send(method) do |request|
          request.url(formatted_path(path), options)
        end
        raw ? response : response.body
      end

      def formatted_path(path)
        [path, format].compact.join('.')
      end
    end
  end
end

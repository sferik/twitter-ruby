require 'twitter/headers'

module Twitter
  module REST
    module RequestOptions
      # Set the request method, content type, and headers on the client
      #
      # @param request_method [Symbol] Desired request method
      # @param options [Hash] the content body
      # @return [void]
      def create_request_options!(request_method, options)
        if request_method == :multipart_post
          create_multipart_options!(options)
        elsif request_method == :json_post
          create_json_options!
        else
          create_standard_options!(request_method, options)
        end
      end

    private

      def merge_multipart_file!(options)
        key = options.delete(:key)
        file = options.delete(:file)

        options[key] = if file.is_a?(StringIO)
                         HTTP::FormData::File.new(file, mime_type: 'video/mp4')
                       else
                         HTTP::FormData::File.new(file, filename: File.basename(file), mime_type: mime_type(File.basename(file)))
                       end
      end

      def create_multipart_options!(options)
        merge_multipart_file!(options)
        @request_method = :post
        @options_key = :form
        @headers = Twitter::Headers.new(@client, @request_method, @uri).request_headers
      end

      def create_json_options!
        @options_key = :json
        @request_method = :post
        @headers = Twitter::Headers.new(@client, @request_method, @uri).request_headers
      end

      def create_standard_options!(request_method, options)
        @request_method = request_method
        @options_key = @request_method == :get ? :params : :form
        @headers = Twitter::Headers.new(@client, @request_method, @uri, options).request_headers
      end

      def mime_type(basename)
        case basename
        when /\.gif$/i
          'image/gif'
        when /\.jpe?g/i
          'image/jpeg'
        when /\.png$/i
          'image/png'
        else
          'application/octet-stream'
        end
      end
    end
  end
end

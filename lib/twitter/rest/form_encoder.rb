module Twitter
  module REST
    # Encodes form data for HTTP requests
    class FormEncoder
      # Characters that don't need to be escaped
      UNESCAPED_CHARS = /[^a-z0-9\-._~]/i

      # Encodes data hash into form-encoded string
      #
      # @api public
      # @example
      #   Twitter::REST::FormEncoder.encode(name: "test", value: 123)
      # @param data [Hash] The data to encode
      # @return [String]
      def self.encode(data)
        data.collect { |k, v| encode_pair(k, v) }.join("&")
      end

      # Encodes a key-value pair
      #
      # @api private
      # @param key [Object] The key to encode
      # @param value [Object] The value to encode
      # @return [String]
      def self.encode_pair(key, value)
        if value.nil?
          escape(key)
        elsif value.respond_to?(:to_ary)
          encode_array(key, value.to_ary)
        else
          "#{escape(key)}=#{escape(value)}"
        end
      end

      # Encodes an array of values with the same key
      #
      # @api private
      # @param key [Object] The key to encode
      # @param array [Array] The array of values
      # @return [String]
      def self.encode_array(key, array)
        array.collect { |item| encode_array_item(key, item) }.join("&")
      end

      # Encodes a single array item
      #
      # @api private
      # @param key [Object] The key to encode
      # @param item [Object] The item to encode
      # @return [String]
      def self.encode_array_item(key, item)
        item.nil? ? escape(key) : "#{escape(key)}=#{escape(item)}"
      end

      # URI escapes a value
      #
      # @api private
      # @param value [Object] The value to escape
      # @return [String]
      def self.escape(value)
        ::URI::DEFAULT_PARSER.escape(value.to_s, UNESCAPED_CHARS) # steep:ignore UnknownConstant
      end

      private_class_method :encode_pair, :encode_array, :encode_array_item, :escape
    end
  end
end

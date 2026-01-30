module Twitter
  module REST
    class FormEncoder
      UNESCAPED_CHARS = /[^a-z0-9\-._~]/i

      def self.encode(data)
        data.collect { |k, v| encode_pair(k, v) }.join("&")
      end

      def self.encode_pair(key, value)
        if value.nil?
          escape(key)
        elsif value.respond_to?(:to_ary)
          encode_array(key, value.to_ary)
        else
          "#{escape(key)}=#{escape(value)}"
        end
      end

      def self.encode_array(key, array)
        array.collect { |item| encode_array_item(key, item) }.join("&")
      end

      def self.encode_array_item(key, item)
        item.nil? ? escape(key) : "#{escape(key)}=#{escape(item)}"
      end

      def self.escape(value)
        ::URI::DEFAULT_PARSER.escape(value.to_s, UNESCAPED_CHARS)
      end

      private_class_method :encode_pair, :encode_array, :encode_array_item, :escape
    end
  end
end

module Twitter
  module REST
    class FormEncoder
      UNESCAPED_CHARS = /[^a-z0-9\-._~]/i

      def self.encode(data)
        data.collect do |k, v|
          if v.nil?
            ::URI::DEFAULT_PARSER.escape(k.to_s, UNESCAPED_CHARS)
          elsif v.respond_to?(:to_ary)
            v.to_ary.collect do |w|
              str = ::URI::DEFAULT_PARSER.escape(k.to_s, UNESCAPED_CHARS)
              unless w.nil?
                str << "="
                str << ::URI::DEFAULT_PARSER.escape(w.to_s, UNESCAPED_CHARS)
              end
            end.join("&")
          else
            str = ::URI::DEFAULT_PARSER.escape(k.to_s, UNESCAPED_CHARS)
            str << "="
            str << ::URI::DEFAULT_PARSER.escape(v.to_s, UNESCAPED_CHARS)
          end
        end.join("&")
      end
    end
  end
end

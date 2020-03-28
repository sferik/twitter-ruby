class FormEncoder
  def self.encode(data)
    unescaped_chars = /[^a-z0-9\-\.\_\~]/i
    data.map do |k, v|
      if v.nil?
        ::URI::DEFAULT_PARSER.escape(k.to_s, unescaped_chars)
      elsif v.respond_to?(:to_ary)
        v.to_ary.map do |w|
          str = ::URI::DEFAULT_PARSER.escape(k.to_s, unescaped_chars)
          unless w.nil?
            str << '='
            str << ::URI::DEFAULT_PARSER.escape(w.to_s, unescaped_chars)
          end
        end.join('&')
      else
        str = ::URI::DEFAULT_PARSER.escape(k.to_s, unescaped_chars)
        str << '='
        str << ::URI::DEFAULT_PARSER.escape(v.to_s, unescaped_chars)
      end
    end.join('&')
  end
end

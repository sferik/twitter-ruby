module URI
  class << self
    def parser
      @parser ||= URI::Parser.new
    end unless method_defined? :parser
  end
end

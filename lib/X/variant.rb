require "X/base"

module X
  class Variant < X::Base
    # @return [Integer]
    attr_reader :bitrate

    # @return [String]
    attr_reader :content_type

    uri_attr_reader :uri
  end
end

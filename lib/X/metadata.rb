require "X/base"

module X
  class Metadata < X::Base
    # @return [String]
    attr_reader :iso_language_code, :result_type
  end
end

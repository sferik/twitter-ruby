require "X/base"

module X
  class Language < X::Base
    # @return [String]
    attr_reader :code, :name, :status
  end
end

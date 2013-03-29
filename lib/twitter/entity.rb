require 'twitter/base'

module Twitter
  class Entity < Twitter::Base
    attr_reader :indices

    # @return [String]
    def id_str
      @attrs[:id_str]
    end
  end
end

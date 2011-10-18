require 'time'

module Twitter
  module Creatable
    attr_reader :created_at

    def initialize(hash={})
      @created_at = Time.parse(hash.delete('created_at')) unless hash['created_at'].nil?
      super(hash)
    end

  end
end

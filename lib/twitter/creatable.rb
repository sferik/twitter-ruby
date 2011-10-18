require 'time'

module Twitter
  module Creatable
    attr_reader :created_at

    def initialize(attributes={})
      attributes = attributes.dup
      @created_at = Time.parse(attributes.delete('created_at')) unless attributes['created_at'].nil?
      super(attributes)
    end

  end
end

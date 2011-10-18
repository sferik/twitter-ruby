require 'twitter/base'
require 'twitter/user'

module Twitter
  class Relationship < Twitter::Base
    attr_reader :source, :target

    def initialize(attributes={})
      attributes = attributes.dup
      @source = Twitter::User.new(attributes.delete('source')) unless attributes['source'].nil?
      @target = Twitter::User.new(attributes.delete('target')) unless attributes['target'].nil?
      super(attributes)
    end

  end
end

require 'twitter/base'
require 'twitter/user'

module Twitter
  class Relationship < Twitter::Base
    attr_reader :source, :target

    def initialize(relationship={})
      @source = Twitter::User.new(relationship.delete('source')) unless relationship['source'].nil?
      @target = Twitter::User.new(relationship.delete('target')) unless relationship['target'].nil?
      super(relationship)
    end

  end
end

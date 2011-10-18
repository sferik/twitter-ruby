require 'twitter/base'
require 'twitter/user'

module Twitter
  class Relationship < Twitter::Base
    attr_reader :source, :target

    def initialize(relationship={})
      @source = Twitter::User.new(relationship['source']) unless relationship['source'].nil?
      @target = Twitter::User.new(relationship['target']) unless relationship['target'].nil?
    end

  end
end

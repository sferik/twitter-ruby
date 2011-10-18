require 'twitter/base'
require 'twitter/user'

module Twitter
  class Relationship < Twitter::Base

    def source
      @source ||= Twitter::User.new(@attributes['source']) unless @attributes['source'].nil?
    end

    def target
      @target ||= Twitter::User.new(@attributes['target']) unless @attributes['target'].nil?
    end

  end
end

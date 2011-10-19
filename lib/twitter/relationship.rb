require 'twitter/base'
require 'twitter/user'

module Twitter
  class Relationship < Twitter::Base

    def source
      @source ||= Twitter::User.new(@attrs['source']) unless @attrs['source'].nil?
    end

    def target
      @target ||= Twitter::User.new(@attrs['target']) unless @attrs['target'].nil?
    end

  end
end

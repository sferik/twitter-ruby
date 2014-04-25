require 'equalizer'
require 'twitter/base'

module Twitter
  class Suggestion < Twitter::Base
    include Equalizer.new(:slug)
    attr_reader :name, :size, :slug

    # @return [Array<Twitter::User>]
    def users
      @attrs.fetch(:users, []).collect do |user|
        User.new(user)
      end
    end
    memoize :users
  end
end

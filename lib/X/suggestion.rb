require "equalizer"
require "memoizable"
require "X/base"

module X
  class Suggestion < X::Base
    include Equalizer.new(:slug)
    include Memoizable

    # @return [Integer]
    attr_reader :size
    # @return [String]
    attr_reader :name, :slug

    # @return [Array<X::User>]
    def users
      @attrs.fetch(:users, []).collect do |user|
        User.new(user)
      end
    end
    memoize :users
  end
end

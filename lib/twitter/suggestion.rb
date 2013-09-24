require 'equalizer'
require 'twitter/base'

module Twitter
  class Suggestion < Twitter::Base
    include Equalizer.new(:slug)
    attr_reader :name, :size, :slug

    # @return [Array<Twitter::User>]
    def users
      memoize(:users) do
        Array(@attrs[:users]).map do |user|
          Twitter::User.new(user)
        end
      end
    end

  end
end

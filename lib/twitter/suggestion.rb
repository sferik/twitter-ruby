require 'twitter/base'
require 'twitter/user'

module Twitter
  class Suggestion < Twitter::Base
    attr_reader :name, :size, :slug, :users

    def initialize(suggestion={})
      @name = suggestion['name']
      @size = suggestion['size']
      @slug = suggestion['slug']
      @users = suggestion['users'].map do |user|
        Twitter::User.new(user)
      end unless suggestion['users'].nil?
    end

    def ==(other)
      super || (other.class == self.class && other.instance_variable_get('@slug'.to_sym) == @slug)
    end

  end
end

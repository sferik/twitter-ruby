require 'twitter/base'
require 'twitter/user'

module Twitter
  class List < Twitter::Base
    attr_reader :description, :following, :full_name, :id, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri, :user
    alias :following? :following

    def initialize(list={})
      @description = list['description']
      @following = list['following']
      @full_name = list['full_name']
      @id = list['id']
      @member_count = list['member_count']
      @mode = list['mode']
      @name = list['name']
      @slug = list['slug']
      @subscriber_count = list['subscriber_count']
      @uri = list['uri']
      @user = Twitter::User.new(list['user']) unless list['user'].nil?
    end

    def ==(other)
      super || (other.class == self.class && other.id == @id)
    end

  end
end

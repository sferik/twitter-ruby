require 'twitter/base'
require 'twitter/rate_limit'
require 'twitter/user'

module Twitter
  class Relationship < Twitter::Base

    # @return [Twitter::User]
    def source
      @source ||= Twitter::User.fetch_or_new(@attrs[:source]) unless @attrs[:source].nil?
    end

    # @return [Twitter::User]
    def target
      @target ||= Twitter::User.fetch_or_new(@attrs[:target]) unless @attrs[:target].nil?
    end

    # Update the attributes of a Relationship
    #
    # @param attrs [Hash]
    # @return [Twitter::Relationship]
    def update(attrs)
      @attrs ||= {}
      @attrs.update(attrs[:relationship]) unless attrs[:relationship].nil?
      self
    end

  end
end

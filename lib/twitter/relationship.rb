require 'twitter/base'
require 'twitter/source_user'
require 'twitter/target_user'

module Twitter
  class Relationship < Twitter::Base

    # @return [Twitter::User]
    def source
      @source ||= Twitter::SourceUser.fetch_or_new(@attrs[:source]) unless @attrs[:source].nil?
    end

    # @return [Twitter::User]
    def target
      @target ||= Twitter::TargetUser.fetch_or_new(@attrs[:target]) unless @attrs[:target].nil?
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

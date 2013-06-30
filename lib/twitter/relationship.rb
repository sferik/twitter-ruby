require 'twitter/base'

module Twitter
  class Relationship < Twitter::Base

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Twitter::Relationship]
    def initialize(attrs={})
      @attrs = attrs[:relationship]
    end

    # @return [Twitter::SourceUser]
    def source
      @source ||= Twitter::SourceUser.new(@attrs[:source]) unless @attrs[:source].nil?
    end

    # @return [Twitter::TargetUser]
    def target
      @target ||= Twitter::TargetUser.new(@attrs[:target]) unless @attrs[:target].nil?
    end

    # Update the attributes of a Relationship
    #
    # @param attrs [Hash]
    # @return [Twitter::Relationship]
    def update(attrs)
      @attrs.update(attrs[:relationship]) unless attrs[:relationship].nil?
      self
    end

  end
end

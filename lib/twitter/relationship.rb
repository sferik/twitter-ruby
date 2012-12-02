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
      @source ||= Twitter::SourceUser.fetch_or_new(@attrs[:source])
    end

    # @return [Twitter::TargetUser]
    def target
      @target ||= Twitter::TargetUser.fetch_or_new(@attrs[:target])
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

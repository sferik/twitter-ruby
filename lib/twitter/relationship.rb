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

    # @return [Twitter::SourceUser, Twitter::NullObject]
    def source
      new_or_null_object(Twitter::SourceUser, :source)
    end

    # @return [Boolean]
    def source?
      !source.nil?
    end

    # @return [Twitter::TargetUser, Twitter::NullObject]
    def target
      new_or_null_object(Twitter::TargetUser, :target)
    end

    # @return [Boolean]
    def target?
      !target.nil?
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

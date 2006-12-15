# This is pretty much just a macro for creating a class that allows
# using a block to initialize stuff and to define getters and setters
# really quickly.
module Twitter
  module EasyClassMaker
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      # creates the attributes class variable and creates each attribute's accessor methods
      def attributes(*attrs)
        @@attributes = attrs
        @@attributes.each { |a| attr_accessor a }
      end
      
      # read method for attributes class variable
      def self.attributes; @@attributes end
    end
    
    # allows for any class that includes this to use a block to initialize
    # variables instead of assigning each one seperately
    # 
    # Example: 
    # 
    # instead of...
    # 
    # s = Status.new
    # s.foo = 'thing'
    # s.bar = 'another thing'
    #
    # you can ...
    # 
    # Status.new do |s|
    #   s.foo = 'thing'
    #   s.bar = 'another thing'
    # end
    def initialize
      yield self if block_given?
    end
  end
end
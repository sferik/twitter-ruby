module Kernel

  # Returns the object's singleton class (exists in Ruby 1.9.2)
  def singleton_class; class << self; self; end; end unless method_defined?(:singleton_class)

end

module Kernel

  def calling_method
    caller[1][/`([^']*)'/, 1].to_sym
  end

  # Returns the object's singleton class (exists in Ruby 1.9.2)
  def singleton_class; class << self; self; end; end unless method_defined?(:singleton_class)

  # class_eval on an object acts like singleton_class.class_eval.
  def class_eval(*args, &block)
    singleton_class.class_eval(*args, &block)
  end

end

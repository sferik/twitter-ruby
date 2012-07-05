class Array

  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end unless method_defined?(:extract_options!)

end

class String

  # Converts a snake_case string to CamelCase
  #
  # @return [String]
  def camelize
    self.split('_').map(&:capitalize).join
  end unless method_defined?(:camelize)

end

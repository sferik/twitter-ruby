class String

  # Converts a snake_case string to CamelCase
  #
  # @return [String]
  def camelize
    self.gsub(/\/(.?)/){"::#{$1.upcase}"}.gsub(/(?:^|_)(.)/){$1.upcase}
  end unless respond_to?(:camelize)

end

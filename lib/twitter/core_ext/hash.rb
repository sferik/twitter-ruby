class Hash

  # Return a hash that includes everything but the given keys.
  #
  # @param keys [Array, Set]
  # @return [Hash]
  def except(*keys)
    self.dup.except!(*keys)
  end unless method_defined?(:except)

  # Replaces the hash without the given keys.
  #
  # @param keys [Array, Set]
  # @return [Hash]
  def except!(*keys)
    keys.each{|key| delete(key)}
    self
  end unless method_defined?(:except!)

end

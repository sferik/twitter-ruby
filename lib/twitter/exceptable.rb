module Twitter
  module Exceptable

    # Return a hash that includes everything but the given keys.
    #
    # @param hash [Hash]
    # @param key [Symbol]
    # @return [Hash]
    def except(hash, key)
      except!(hash.dup, key)
    end

    # Replaces the hash without the given keys.
    #
    # @param hash [Hash]
    # @param key [Symbol]
    # @return [Hash]
    def except!(hash, key)
      hash.delete(key)
      hash
    end

  end
end

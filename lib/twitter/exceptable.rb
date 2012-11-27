module Twitter
  module Exceptable

  private

    # Return a hash that includes everything but the given keys.
    #
    # @param klass [Class]
    # @param hash [Hash]
    # @param key1 [Symbol]
    # @param key2 [Symbol]
    def fetch_or_new_without_self(klass, hash, key1, key2)
      klass.fetch_or_new(hash.dup[key1].merge(key2 => except(hash, key1))) unless hash[key1].nil?
    end

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

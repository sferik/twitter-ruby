class Hash

  # Return a hash that includes everything but the given keys.
  #
  # @param keys [Array, Set]
  # @return [Hash]
  def except(*keys)
    dup.except!(*keys)
  end

  # Replaces the hash without the given keys.
  #
  # @param keys [Array, Set]
  # @return [Hash]
  def except!(*keys)
    keys.each{|key| delete(key)}
    self
  end

  # Merges self with another hash, recursively
  #
  # @param hash [Hash] The hash to merge
  # @return [Hash]
  def deep_merge(hash)
    target = self.dup
    hash.keys.each do |key|
      if hash[key].is_a?(Hash) && self[key].is_a?(Hash)
        target[key] = target[key].deep_merge(hash[key])
        next
      end
      target[key] = hash[key]
    end
    target
  end

  # Take a list and merge it into the hash with the correct key
  #
  # @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
  # @return [Hash]
  def merge_list!(list)
    case list
    when Integer
      self[:list_id] = list
    when String
      self[:slug] = list
    when Twitter::List
      if list.id
        self[:list_id] = list.id
      elsif list.slug
        self[:slug] = list.slug
      end
      self.merge_owner!(list.user)
    end
    self
  end

  # Take an owner and merge it into the hash with the correct key
  #
  # @param user[Integer, String, Twitter::User] A Twitter user ID, screen_name, or object.
  # @return [Hash]
  def merge_owner!(user)
    self.merge_user!(user, "owner")
    self[:owner_id] = self.delete(:owner_user_id) unless self[:owner_user_id].nil?
    self
  end

  # Take a user and merge it into the hash with the correct key
  #
  # @param user[Integer, String, Twitter::User] A Twitter user ID, screen_name, or object.
  # @return [Hash]
  def merge_user!(user, prefix=nil, suffix=nil)
    case user
    when Integer
      self[[prefix, "user_id", suffix].compact.join("_").to_sym] = user
    when String
      self[[prefix, "screen_name", suffix].compact.join("_").to_sym] = user
    when Twitter::User
      if user.id
        self[[prefix, "user_id", suffix].compact.join("_").to_sym] = user.id
      elsif user.screen_name
        self[[prefix, "screen_name", suffix].compact.join("_").to_sym] = user.screen_name
      end
    end
    self
  end

  # Take a multiple users and merge them into the hash with the correct keys
  #
  # @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen_names, or objects.
  # @return [Hash]
  def merge_users!(*users)
    user_ids, screen_names = [], []
    users.flatten.each do |user|
      case user
      when Integer
        user_ids << user
      when String
        screen_names << user
      when Twitter::User
        if user.id
          user_ids << user.id
        elsif user.screen_name
          screen_names << user.screen_name
        end
      end
    end
    self[:user_id] = user_ids.join(',') unless user_ids.empty?
    self[:screen_name] = screen_names.join(',') unless screen_names.empty?
    self
  end

end

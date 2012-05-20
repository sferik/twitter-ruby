class Hash

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

  # Take a single user ID or screen name and merge it into self with the correct key
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

  # Take a multiple user IDs and screen names and merge them into self with the correct keys
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

  # Take a single owner ID or owner screen name and merge it into self with the correct key
  # (for Twitter API endpoints that want :owner_id and :owner_screen_name)
  #
  # @param user[Integer, String, Twitter::User] A Twitter user ID, screen_name, or object.
  # @return [Hash]
  def merge_owner!(user)
    self.merge_user!(user, "owner")
    self[:owner_id] = self.delete(:owner_user_id) unless self[:owner_user_id].nil?
    self
  end

  # Take a single list ID or slug and merge it into self with the correct key
  #
  # @param list_id_or_slug [Integer, String] A Twitter list ID or slug.
  # @return [Hash]
  def merge_list!(list_id_or_screen_name)
    case list_id_or_screen_name
    when Integer
      self[:list_id] = list_id_or_screen_name
    when String
      self[:slug] = list_id_or_screen_name
    end
    self
  end

end

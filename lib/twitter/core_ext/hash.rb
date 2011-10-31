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
  # @param user_id_or_screen_name [Integer, String] A Twitter user ID or screen_name.
  # @return [Hash]
  def merge_user!(user_id_or_screen_name)
    case user_id_or_screen_name
    when Integer
      self[:user_id] = user_id_or_screen_name
    when String
      self[:screen_name] = user_id_or_screen_name
    end
    self
  end

  # Take a multiple user IDs and screen names and merge them into self with the correct keys
  #
  # @param users_id_or_screen_names [Array] An array of Twitter user IDs or screen_names.
  # @return [Hash]
  def merge_users!(user_ids_or_screen_names)
    user_ids, screen_names = [], []
    user_ids_or_screen_names.flatten.each do |user_id_or_screen_name|
      case user_id_or_screen_name
      when Integer
        user_ids << user_id_or_screen_name
      when String
        screen_names << user_id_or_screen_name
      end
    end
    self[:user_id] = user_ids.join(',') unless user_ids.empty?
    self[:screen_name] = screen_names.join(',') unless screen_names.empty?
    self
  end

  # Take a single owner ID or owner screen name and merge it into self with the correct key
  # (for Twitter API endpoints that want :owner_id and :owner_screen_name)
  #
  # @param owner_id_or_owner_screen_name [Integer, String] A Twitter user ID or screen_name.
  # @return [Hash]
  def merge_owner!(owner_id_or_owner_screen_name)
    case owner_id_or_owner_screen_name
    when Integer
      self[:owner_id] = owner_id_or_owner_screen_name
    when String
      self[:owner_screen_name] = owner_id_or_owner_screen_name
    end
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

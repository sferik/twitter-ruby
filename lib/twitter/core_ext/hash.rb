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
      self[:list_id] = list.id
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
  def merge_user(user, prefix=nil)
    self.dup.merge_user!(user, prefix)
  end

  # Take a user and merge it into the hash with the correct key
  #
  # @param user[Integer, String, Twitter::User] A Twitter user ID, screen_name, or object.
  # @return [Hash]
  def merge_user!(user, prefix=nil)
    case user
    when Integer
      self[[prefix, "user_id"].compact.join("_").to_sym] = user
    when String
      self[[prefix, "screen_name"].compact.join("_").to_sym] = user
    when Twitter::User
      self[[prefix, "user_id"].compact.join("_").to_sym] = user.id
    end
    self
  end

  # Take a multiple users and merge them into the hash with the correct keys
  #
  # @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen_names, or objects.
  # @return [Hash]
  def merge_users(*users)
    self.dup.merge_users!(*users)
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
        user_ids << user.id
      end
    end
    self[:user_id] = user_ids.join(',') unless user_ids.empty?
    self[:screen_name] = screen_names.join(',') unless screen_names.empty?
    self
  end

end

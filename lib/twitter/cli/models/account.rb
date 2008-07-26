class Account < ActiveRecord::Base
  named_scope :current, :conditions => {:current => true}
  
  has_many :tweets, :dependent => :destroy
  
  def self.add(hash)
    username = hash.delete(:username)
    account = find_or_initialize_by_username(username)
    account.attributes = hash
    account.save
    set_current(account) if new_active_needed?
  end
  
  def self.active
    current.first
  end
  
  def self.set_current(account_or_id)
    account = account_or_id.is_a?(Account) ? account_or_id : find(account_or_id)
    account.update_attribute :current, true
    Account.update_all "current = 0", "id != #{account.id}"
    account
  end
  
  def self.new_active_needed?
    self.current.count == 0 && self.count > 0
  end
  
  def to_s
    "#{current? ? '*' : ' '} #{username}"
  end
  alias to_str to_s
end

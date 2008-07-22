class Account < ActiveRecord::Base
  named_scope :current, :conditions => {:current => true}
  
  has_many :tweets, :dependent => :destroy
  
  def self.active
    current.first
  end
  
  def self.set_current(account_or_id)
    account = account_or_id.is_a?(Account) ? account_or_id : find(account_or_id)
    account.update_attribute :current, true
    Account.update_all "current = 0", "id != #{account.id}"
    account
  end
  
  def to_s
    "#{current? ? '*' : ' '} #{username}"
  end
  alias to_str to_s
end

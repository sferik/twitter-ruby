class AddAccountIdToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :account_id, :integer
  end

  def self.down
    remove_column :tweets, :account_id
  end
end

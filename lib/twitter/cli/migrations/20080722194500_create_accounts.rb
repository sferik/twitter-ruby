class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :username, :password
      t.boolean :current
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end

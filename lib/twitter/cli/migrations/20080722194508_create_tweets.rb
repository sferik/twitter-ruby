class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.datetime :occurred_at
      t.boolean :truncated, :favorited, :user_protected, :default => false
      t.integer :twitter_id, :user_id, :in_reply_to_status_id, :in_reply_to_user_id, :user_followers_count
      t.text :body
      t.string :source, :user_name, :user_screen_name, :user_location, :user_description, :user_profile_image_url, :user_url
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end

class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :status_id, :in_reply_to_user_id, :in_reply_to_status_id
      t.string :text, :in_reply_to_screen_name
      t.datetime :tweeted_at
    end
  end

  def self.down
    drop_table :tweets
  end
end

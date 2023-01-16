class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.integer :chat_id
      t.string :feed_url
      t.datetime :last_update_at
      t.timestamps
    end
  end
end
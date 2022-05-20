class CreateChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :channels do |t|
      t.text :youtube_channel_id, null: false, index: { unique: true }
      t.text :youtube_url, null: false
      t.text :feed_url, null: false
      t.text :name, null: false
      t.datetime :last_fetch_attempt, null: true
      t.datetime :feed_last_modified, null: true
      t.integer :last_fetch_status, null: false, default: 0
      t.timestamps
    end
  end
end

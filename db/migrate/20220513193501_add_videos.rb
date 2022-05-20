class AddVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.text :title, null: false
      t.text :description, null: false
      t.text :youtube_url, null: false
      t.text :thumbnail_url, null: false
      t.text :youtube_video_id, null: false, index: { unique: true }
      t.integer :status, null: false, default: 0
      t.datetime :video_published_at, null: false
      t.datetime :video_updated_at, null: false
      t.references :channel, null: false, foreign_key: true
      t.timestamps
    end
  end
end

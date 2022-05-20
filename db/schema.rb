# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_05_13_193501) do
  create_table "channels", force: :cascade do |t|
    t.text "youtube_channel_id", null: false
    t.text "youtube_url", null: false
    t.text "feed_url", null: false
    t.text "name", null: false
    t.datetime "last_fetch_attempt"
    t.datetime "feed_last_modified"
    t.integer "last_fetch_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["youtube_channel_id"], name: "index_channels_on_youtube_channel_id", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.text "title", null: false
    t.text "description", null: false
    t.text "youtube_url", null: false
    t.text "thumbnail_url", null: false
    t.text "youtube_video_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "video_published_at", null: false
    t.datetime "video_updated_at", null: false
    t.integer "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_videos_on_channel_id"
    t.index ["youtube_video_id"], name: "index_videos_on_youtube_video_id", unique: true
  end

  add_foreign_key "videos", "channels"
end

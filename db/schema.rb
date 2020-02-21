# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_21_220123) do

  create_table "costume_assignments", force: :cascade do |t|
    t.integer "dancer_id"
    t.integer "costume_id"
    t.string "costume_condition"
    t.string "costume_size"
    t.string "song_name"
    t.string "dance_season"
    t.string "genre"
    t.string "shoe"
    t.string "tight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "costumes", force: :cascade do |t|
    t.text "top_description"
    t.text "bottoms_description"
    t.text "onepiece_description"
    t.string "picture"
    t.string "hair_accessory"
    t.integer "dance_studio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dance_studios", force: :cascade do |t|
    t.string "studio_name"
    t.string "owner_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_token"
    t.string "google_refresh_token"
  end

  create_table "dancers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "birthdate"
    t.string "email"
    t.string "phone_number"
    t.boolean "current_dancer", default: true
    t.integer "dance_studio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end

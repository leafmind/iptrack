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

ActiveRecord::Schema[8.1].define(version: 2026_09_07_094801) do
  create_table "api_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "role", default: 0, null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_keys_on_token", unique: true
  end

  create_table "geocodes", force: :cascade do |t|
    t.integer "api_key_id", null: false
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.boolean "host", default: false, null: false
    t.float "latitude"
    t.float "longitude"
    t.json "payload"
    t.string "target", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key_id"], name: "index_geocodes_on_api_key_id"
    t.index ["target"], name: "index_geocodes_on_target", unique: true
  end

  add_foreign_key "geocodes", "api_keys"
end

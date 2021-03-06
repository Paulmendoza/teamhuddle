# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150503234057) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "archived_sport_event_instances", force: true do |t|
    t.integer  "sport_event_id"
    t.integer  "datetime_start"
    t.integer  "datetime_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beta_testers", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_us", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.integer  "location_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id"

  create_table "locations", force: true do |t|
    t.string   "address"
    t.decimal  "lat"
    t.decimal  "long"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.integer  "user_id"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
  end

  create_table "reviews", force: true do |t|
    t.integer  "rating"
    t.text     "review"
    t.integer  "user_id"
    t.integer  "sport_event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sport_event_instances", force: true do |t|
    t.integer  "sport_event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "datetime_start"
    t.datetime "datetime_end"
  end

  create_table "sport_events", force: true do |t|
    t.integer  "event_id"
    t.string   "sport_id"
    t.string   "type"
    t.string   "skill_level"
    t.decimal  "price_per_one"
    t.decimal  "price_per_group"
    t.integer  "spots"
    t.integer  "spots_filled"
    t.string   "gender"
    t.text     "notes"
    t.string   "format"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "schedule"
    t.string   "source"
    t.datetime "deleted_at"
    t.integer  "admin_id"
    t.boolean  "is_active",       default: true, null: false
    t.datetime "dt_expiry",                      null: false
  end

  add_index "sport_events", ["admin_id"], name: "index_sport_events_on_admin_id"
  add_index "sport_events", ["deleted_at"], name: "index_sport_events_on_deleted_at"

  create_table "sports", id: false, force: true do |t|
    t.string   "sport",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sports", ["sport"], name: "index_sports_on_sport", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "provider"
    t.string   "uid"
    t.string   "image_url"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

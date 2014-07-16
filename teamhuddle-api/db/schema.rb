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

ActiveRecord::Schema.define(version: 20140715044347) do

  create_table "archived_sport_event_instances", force: true do |t|
    t.integer  "sport_event_id"
    t.integer  "datetime_start"
    t.integer  "datetime_end"
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

  create_table "locations", force: true do |t|
    t.string   "address"
    t.decimal  "lat"
    t.decimal  "long"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.integer  "user_id"
    t.integer  "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recurring_events", force: true do |t|
    t.integer  "event_id"
    t.integer  "date_start"
    t.integer  "date_end"
    t.integer  "time_start"
    t.integer  "time_end"
    t.text     "ical_string"
    t.string   "integer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sport_event_instances", force: true do |t|
    t.integer  "sport_event_id"
    t.integer  "datetime_start"
    t.integer  "datetime_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sport_events", force: true do |t|
    t.integer  "event_id"
    t.string   "sport"
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
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "salthashpass"
    t.string   "salt"
    t.string   "first_name"
    t.string   "locale"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

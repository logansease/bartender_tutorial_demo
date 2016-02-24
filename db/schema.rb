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

ActiveRecord::Schema.define(version: 20140925143250) do

  create_table "bartenders", force: true do |t|
    t.string   "bar"
    t.integer  "user_id"
    t.boolean  "is_working"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background"
  end

  create_table "base_objects", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "pages", force: true do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "content"
  end

  add_index "pages", ["title"], name: "index_pages_on_title"

  create_table "relationships", force: true do |t|
    t.string   "relationship_type"
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.boolean  "is_unsubscribed",   default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              default: false
    t.float    "fb_user_id"
    t.boolean  "activated",          default: false
    t.boolean  "recover_password",   default: false
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["fb_user_id"], name: "index_users_on_fb_user_id"

end

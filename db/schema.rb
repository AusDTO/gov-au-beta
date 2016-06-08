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

ActiveRecord::Schema.define(version: 20160607010429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "content_blocks", force: :cascade do |t|
    t.integer  "node_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["node_id"], name: "index_content_blocks_on_node_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "nodes", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "parent_id"
    t.string   "template"
    t.string   "name"
    t.string   "slug"
    t.integer  "order_num"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "state",      default: "draft", null: false
    t.text     "type"
    t.jsonb    "data"
    t.string   "token"
    t.index ["parent_id"], name: "index_nodes_on_parent_id", using: :btree
    t.index ["section_id"], name: "index_nodes_on_section_id", using: :btree
    t.index ["token"], name: "index_nodes_on_token", unique: true, using: :btree
  end

  create_table "previews", force: :cascade do |t|
    t.string   "token"
    t.json     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_previews_on_token", unique: true, using: :btree
  end

  create_table "sections", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "layout"
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name"
    t.string   "preview_image_id"
    t.string   "preview_image_filename"
    t.string   "preview_image_size"
    t.string   "preview_image_content_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_admin",               default: false, null: false
    t.boolean  "is_author",              default: false, null: false
    t.boolean  "is_reviewer",            default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "content_blocks", "nodes"
end

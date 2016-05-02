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

ActiveRecord::Schema.define(version: 20160502065034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "content_blocks", force: :cascade do |t|
    t.integer  "node_id"
    t.text     "body"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["node_id"], name: "index_content_blocks_on_node_id", using: :btree
  end

  create_table "nodes", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "template_id"
    t.integer  "parent_node_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["parent_node_id"], name: "index_nodes_on_parent_node_id", using: :btree
    t.index ["section_id"], name: "index_nodes_on_section_id", using: :btree
    t.index ["template_id"], name: "index_nodes_on_template_id", using: :btree
  end

  create_table "sections", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "preview_image_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_foreign_key "content_blocks", "nodes"
end

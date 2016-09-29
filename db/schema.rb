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

ActiveRecord::Schema.define(version: 20160921001553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.integer  "uploader_id"
    t.string   "asset_file_file_name"
    t.string   "asset_file_content_type"
    t.integer  "asset_file_file_size"
    t.datetime "asset_file_updated_at"
    t.string   "asset_file_fingerprint"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alttext"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "short_summary"
    t.text     "summary"
    t.integer  "parent_id"
    t.integer  "children_count"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "placeholder",    default: false, null: false
    t.index ["slug"], name: "index_categories_on_slug", using: :btree
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string   "url"
    t.string   "role"
    t.string   "organisation"
    t.string   "email"
    t.text     "comment"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
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

  create_table "invites", force: :cascade do |t|
    t.string   "code"
    t.string   "accepted_token"
    t.datetime "accepted_at"
    t.string   "email"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["accepted_token"], name: "index_invites_on_accepted_token", unique: true, using: :btree
    t.index ["code"], name: "index_invites_on_code", unique: true, using: :btree
  end

  create_table "news_distributions", force: :cascade do |t|
    t.string   "distribution_type"
    t.integer  "distribution_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "acknowledged"
    t.integer  "news_article_id"
    t.index ["distribution_type", "distribution_id"], name: "index_news_distro_on_type_and_id", using: :btree
  end

  create_table "nodes", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "parent_id"
    t.string   "template"
    t.string   "name"
    t.string   "slug"
    t.integer  "order_num"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "type"
    t.jsonb    "data"
    t.string   "state",        default: "draft", null: false
    t.string   "token"
    t.string   "cms_url"
    t.string   "cms_api_url"
    t.jsonb    "content"
    t.datetime "published_at"
    t.index ["parent_id", "slug"], name: "index_nodes_on_parent_id_and_slug", unique: true, using: :btree
    t.index ["parent_id"], name: "index_nodes_on_parent_id", using: :btree
    t.index ["section_id"], name: "index_nodes_on_section_id", using: :btree
    t.index ["token"], name: "index_nodes_on_token", unique: true, using: :btree
    t.index ["type"], name: "index_nodes_on_type", using: :btree
  end

  create_table "requests", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "user_id"
    t.integer  "approver_id"
    t.string   "state",       default: "requested", null: false
    t.text     "message"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["approver_id"], name: "index_requests_on_approver_id", using: :btree
    t.index ["section_id"], name: "index_requests_on_section_id", using: :btree
    t.index ["user_id"], name: "index_requests_on_user_id", using: :btree
  end

  create_table "revisions", id: :uuid, default: nil, force: :cascade do |t|
    t.string   "revisable_type"
    t.integer  "revisable_id"
    t.jsonb    "diffs"
    t.datetime "created_at"
    t.datetime "applied_at"
    t.uuid     "parent_id"
    t.index ["revisable_type", "revisable_id"], name: "index_revisions_on_revisable_type_and_revisable_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "section_categories", id: false, force: :cascade do |t|
    t.integer "section_id"
    t.integer "category_id"
    t.index ["category_id"], name: "index_section_categories_on_category_id", using: :btree
    t.index ["section_id"], name: "index_section_categories_on_section_id", using: :btree
  end

  create_table "section_connections", force: :cascade do |t|
    t.integer "section_id"
    t.integer "connection_id"
    t.index ["section_id", "connection_id"], name: "index_section_connections_on_section_id_and_connection_id", unique: true, using: :btree
  end

  create_table "sections", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "layout"
    t.text     "summary"
    t.string   "cms_type",   default: "Collaborate", null: false
    t.string   "cms_url"
    t.string   "cms_path"
    t.text     "image_url"
    t.index ["type"], name: "index_sections_on_type", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.uuid     "revision_id",                    null: false
    t.integer  "submitter_id",                   null: false
    t.integer  "reviewer_id"
    t.text     "summary"
    t.datetime "submitted_at"
    t.datetime "reviewed_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "state",        default: "draft", null: false
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
    t.string   "email",                                default: "",    null: false
    t.string   "encrypted_password",                   default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "confirmation_token"
    t.text     "unconfirmed_email"
    t.integer  "second_factor_attempts_count",         default: 0
    t.string   "encrypted_otp_secret_key"
    t.string   "encrypted_otp_secret_key_iv"
    t.string   "encrypted_otp_secret_key_salt"
    t.string   "direct_otp"
    t.datetime "direct_otp_sent_at"
    t.string   "phone_number"
    t.boolean  "bypass_tfa",                           default: false
    t.boolean  "account_verified"
    t.string   "unconfirmed_phone_number"
    t.string   "unconfirmed_phone_number_otp"
    t.datetime "unconfirmed_phone_number_otp_sent_at"
    t.datetime "identity_verified_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["encrypted_otp_secret_key"], name: "index_users_on_encrypted_otp_secret_key", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  add_foreign_key "assets", "users", column: "uploader_id"
  add_foreign_key "news_distributions", "nodes", column: "news_article_id"
  add_foreign_key "nodes", "nodes", column: "parent_id"
  add_foreign_key "requests", "sections"
  add_foreign_key "requests", "users"
  add_foreign_key "requests", "users", column: "approver_id"
  add_foreign_key "revisions", "revisions", column: "parent_id"
  add_foreign_key "section_categories", "categories"
  add_foreign_key "section_categories", "sections"
  add_foreign_key "section_connections", "sections"
  add_foreign_key "section_connections", "sections", column: "connection_id"
  add_foreign_key "submissions", "revisions"
  add_foreign_key "submissions", "users", column: "reviewer_id"
  add_foreign_key "submissions", "users", column: "submitter_id"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
end

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

ActiveRecord::Schema.define(version: 20150809065940) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "mobile"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "cart_items", force: :cascade do |t|
    t.integer "owner_id"
    t.string  "owner_type"
    t.integer "quantity"
    t.integer "item_id"
    t.string  "item_type"
    t.float   "price"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "level"
    t.integer  "discount"
    t.integer  "store_discount"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "product_id"
    t.decimal  "totalvalue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.boolean  "storage",    default: false
    t.boolean  "processed",  default: false
  end

  create_table "pigs", force: :cascade do |t|
    t.string   "name"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "amount"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.decimal  "price",            default: 0.0
    t.integer  "category_id"
    t.boolean  "storage",          default: false
    t.text     "desc"
    t.string   "pic1"
    t.string   "pic2"
    t.string   "pic3"
    t.string   "pic4"
    t.string   "pic5"
    t.string   "pic6"
    t.string   "pic7"
  end

  create_table "rich_rich_files", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        default: "file"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "mobile"
    t.string   "address"
    t.string   "name"
    t.string   "uname"
    t.string   "level",                  default: "注册用户"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "alipay",                 default: ""
    t.string   "brand_name",             default: ""
    t.decimal  "balance",                default: 0.0
    t.integer  "point",                  default: 0
    t.string   "promotion_code"
    t.string   "pass"
    t.integer  "manager_id"
    t.integer  "parent_id"
    t.string   "source",                 default: "self"
    t.string   "storage",                default: "empty"
    t.string   "reject_msg",             default: "无"
    t.text     "desc"
  end

  add_index "users", ["manager_id"], name: "index_users_on_manager_id"
  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true
  add_index "users", ["parent_id"], name: "index_users_on_parent_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "verifications", force: :cascade do |t|
    t.string   "phone"
    t.string   "email"
    t.datetime "phonetime"
    t.string   "personalid"
    t.string   "phonestatus",          default: "confirming"
    t.string   "emailstatus",          default: "confirming"
    t.string   "idstatus",             default: "confirming"
    t.integer  "securyscore",          default: 0
    t.integer  "user_info_id"
    t.string   "verify_code"
    t.boolean  "phone_confirm_status", default: false
    t.string   "realname"
    t.string   "email_code"
    t.string   "passwd"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

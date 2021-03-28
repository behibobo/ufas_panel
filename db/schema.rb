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

ActiveRecord::Schema.define(version: 2021_03_27_135614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "user_id", null: false
    t.date "valid_to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_accounts_on_plan_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "region", limit: 100
    t.string "code", limit: 20
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "lng"
    t.string "lat"
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "device_name"
    t.string "device_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "device_type"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "days"
    t.string "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "servers", force: :cascade do |t|
    t.string "host"
    t.string "api_key"
    t.integer "server_type"
    t.boolean "premium", default: false
    t.bigint "country_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "port"
    t.string "ip"
    t.index ["country_id"], name: "index_servers_on_country_id"
  end

  create_table "user_connections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "server_id", null: false
    t.string "username"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["server_id"], name: "index_user_connections_on_server_id"
    t.index ["user_id"], name: "index_user_connections_on_user_id"
  end

  create_table "user_servers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "server_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["server_id"], name: "index_user_servers_on_server_id"
    t.index ["user_id"], name: "index_user_servers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "uuid"
    t.string "referral_code"
    t.boolean "online"
    t.date "last_online"
    t.bigint "referred_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
    t.string "activation_code"
    t.integer "user_type", default: 0
    t.index ["referred_by_id"], name: "index_users_on_referred_by_id"
  end

  add_foreign_key "accounts", "plans"
  add_foreign_key "accounts", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "servers", "countries"
  add_foreign_key "user_connections", "servers"
  add_foreign_key "user_connections", "users"
  add_foreign_key "user_servers", "servers"
  add_foreign_key "user_servers", "users"
  add_foreign_key "users", "users", column: "referred_by_id"
end

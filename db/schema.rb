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

ActiveRecord::Schema.define(version: 2021_09_28_214333) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "event_date"
    t.bigint "user_id"
    t.integer "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company"
    t.string "load_type"
    t.integer "account_id"
    t.decimal "load_value", precision: 11
    t.string "load_size"
    t.index ["account_id"], name: "index_documents_on_account_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
    t.index ["vehicle_id"], name: "index_documents_on_vehicle_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.string "identification_id"
    t.string "insurance"
    t.string "pension_company"
    t.text "notes"
    t.string "address"
    t.string "phone_number"
    t.string "mobile_number"
    t.string "email"
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["account_id"], name: "index_drivers_on_account_id"
  end

  create_table "maintenance_types", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "name"], name: "index_maintenance_types_on_account_id_and_name"
    t.index ["account_id"], name: "index_maintenance_types_on_account_id"
  end

  create_table "maintenances", force: :cascade do |t|
    t.text "description"
    t.date "event_date"
    t.decimal "value", precision: 11, default: "0"
    t.bigint "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "maintenance_type_id"
    t.integer "user_id"
    t.integer "register_id"
    t.index ["vehicle_id"], name: "index_maintenances_on_vehicle_id"
  end

  create_table "preload_registers", force: :cascade do |t|
    t.text "description"
    t.integer "register_type"
    t.integer "account_id"
    t.decimal "value", precision: 11, default: "0"
    t.string "notes"
    t.integer "register_sketch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_preload_registers_on_account_id"
    t.index ["register_sketch_id"], name: "index_preload_registers_on_register_sketch_id"
  end

  create_table "register_sketches", force: :cascade do |t|
    t.string "name"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_register_sketches_on_account_id"
  end

  create_table "registers", force: :cascade do |t|
    t.text "description"
    t.date "event_date"
    t.integer "register_type"
    t.integer "vehicle_id"
    t.decimal "value", precision: 11, default: "0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notes"
    t.integer "user_id"
    t.integer "document_id"
    t.index ["document_id"], name: "index_registers_on_document_id"
    t.index ["event_date"], name: "index_registers_on_event_date"
    t.index ["vehicle_id", "event_date"], name: "index_registers_on_vehicle_id_and_event_date"
    t.index ["vehicle_id"], name: "index_registers_on_vehicle_id"
  end

  create_table "savings", force: :cascade do |t|
    t.integer "driver_id"
    t.date "event_date"
    t.integer "amount"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["driver_id"], name: "index_savings_on_driver_id"
    t.index ["user_id"], name: "index_savings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "full_name"
    t.bigint "account_id"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "vehicle_ids", default: [], array: true
    t.integer "role", default: 0
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "license_plate"
    t.string "side_number"
    t.string "model_date"
    t.integer "status", default: 0
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vehicle_type", default: 0
    t.index ["account_id"], name: "index_vehicles_on_account_id"
  end

end

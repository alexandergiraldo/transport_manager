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

ActiveRecord::Schema.define(version: 2024_08_20_000946) do

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

  create_table "accounts_payables", force: :cascade do |t|
    t.string "name"
    t.string "external_invoice"
    t.integer "total_amount"
    t.integer "amount_paid"
    t.integer "balance_due"
    t.integer "recurring_type", default: 0
    t.date "payment_date"
    t.integer "payment_day"
    t.string "notes"
    t.bigint "account_id", null: false
    t.bigint "vehicle_id", null: false
    t.bigint "vendor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_accounts_payables_on_account_id"
    t.index ["vehicle_id"], name: "index_accounts_payables_on_vehicle_id"
    t.index ["vendor_id"], name: "index_accounts_payables_on_vendor_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
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
    t.string "load_manifest"
    t.bigint "driver_id"
    t.decimal "driver_advance", precision: 11
    t.decimal "company_advance", precision: 11
    t.integer "advance_responsible"
    t.decimal "balance_in_favor", precision: 11
    t.integer "balance_in_favor_of", default: 0
    t.decimal "pending_company_amount", precision: 11
    t.decimal "pending_company_amount_paid", precision: 11
    t.date "paid_date"
    t.decimal "retentions", precision: 11
    t.index ["account_id"], name: "index_documents_on_account_id"
    t.index ["driver_id"], name: "index_documents_on_driver_id"
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

  create_table "global_settings", force: :cascade do |t|
    t.integer "day_fee"
    t.bigint "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_global_settings_on_account_id"
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

  create_table "payments", force: :cascade do |t|
    t.date "payment_date"
    t.integer "amount"
    t.integer "payment_method"
    t.bigint "accounts_payable_id", null: false
    t.string "payer_details"
    t.string "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["accounts_payable_id"], name: "index_payments_on_accounts_payable_id"
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
    t.integer "status", default: 0
    t.datetime "paid_date"
    t.bigint "vehicle_id"
    t.index ["driver_id"], name: "index_savings_on_driver_id"
    t.index ["user_id"], name: "index_savings_on_user_id"
    t.index ["vehicle_id"], name: "index_savings_on_vehicle_id"
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

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "email"
    t.string "contact_person"
    t.string "tax_id"
    t.integer "account_number"
    t.string "account_type"
    t.string "bank_name"
    t.string "notes"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_vendors_on_account_id"
  end

  add_foreign_key "accounts_payables", "accounts"
  add_foreign_key "accounts_payables", "vehicles"
  add_foreign_key "accounts_payables", "vendors"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "global_settings", "accounts"
  add_foreign_key "payments", "accounts_payables"
  add_foreign_key "vendors", "accounts"
end

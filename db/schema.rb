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

ActiveRecord::Schema[7.0].define(version: 2024_01_30_161952) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "comment"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
  end

  create_table "combination_of_local_products", force: :cascade do |t|
    t.string "comment"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currency_conversions", force: :cascade do |t|
    t.decimal "rate", precision: 9, scale: 2
    t.boolean "to_uzs", default: true
    t.bigint "user_id", null: false
    t.decimal "price_in_uzs", precision: 18, scale: 2
    t.decimal "price_in_usd", precision: 18, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_currency_conversions_on_user_id"
  end

  create_table "currency_rates", force: :cascade do |t|
    t.decimal "rate", precision: 12, scale: 2
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_transaction_reports", force: :cascade do |t|
    t.decimal "income_in_usd", precision: 18, scale: 2
    t.decimal "income_in_uzs", precision: 18, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_daily_transaction_reports_on_user_id"
  end

  create_table "debt_operations", force: :cascade do |t|
    t.boolean "debt_in_usd", default: true
    t.integer "status", default: 0
    t.decimal "price", precision: 18, scale: 2
    t.bigint "user_id", null: false
    t.bigint "debt_user_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debt_user_id"], name: "index_debt_operations_on_debt_user_id"
    t.index ["user_id"], name: "index_debt_operations_on_user_id"
  end

  create_table "debt_users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_from_counterparties", force: :cascade do |t|
    t.decimal "total_price", precision: 16, scale: 2, default: "0.0"
    t.decimal "total_paid"
    t.integer "payment_type", default: 0
    t.string "comment"
    t.integer "status", default: 0
    t.bigint "provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "price_in_usd", default: false
    t.boolean "with_image", default: false
    t.bigint "product_category_id"
    t.boolean "enable_to_send_sms", default: true
    t.index ["product_category_id"], name: "index_delivery_from_counterparties_on_product_category_id"
    t.index ["provider_id"], name: "index_delivery_from_counterparties_on_provider_id"
    t.index ["user_id"], name: "index_delivery_from_counterparties_on_user_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.bigint "sale_id", null: false
    t.boolean "verified", default: false
    t.boolean "price_in_usd", default: false
    t.decimal "price", precision: 15, scale: 2
    t.string "comment"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_id"], name: "index_discounts_on_sale_id"
    t.index ["user_id"], name: "index_discounts_on_user_id"
  end

  create_table "expenditures", force: :cascade do |t|
    t.bigint "combination_of_local_product_id"
    t.decimal "price", default: "0.0"
    t.decimal "total_paid"
    t.integer "expenditure_type"
    t.integer "payment_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_from_counterparty_id"
    t.boolean "price_in_usd", default: false
    t.string "sale_ids"
    t.boolean "with_image", default: false
    t.bigint "user_id"
    t.string "comment"
    t.index ["combination_of_local_product_id"], name: "index_expenditures_on_combination_of_local_product_id"
    t.index ["delivery_from_counterparty_id"], name: "index_expenditures_on_delivery_from_counterparty_id"
    t.index ["user_id"], name: "index_expenditures_on_user_id"
  end

  create_table "local_services", force: :cascade do |t|
    t.decimal "price", precision: 16, scale: 2
    t.string "comment"
    t.bigint "sale_from_local_service_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_from_local_service_id"], name: "index_local_services_on_sale_from_local_service_id"
    t.index ["user_id"], name: "index_local_services_on_user_id"
  end

  create_table "owners_operations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "operation_type", default: 0
    t.boolean "price_in_usd", default: true
    t.decimal "price", precision: 19, scale: 2
    t.bigint "operator_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_owners_operations_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
  end

  create_table "product_entries", force: :cascade do |t|
    t.decimal "buy_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "sell_price", precision: 10, scale: 2, default: "0.0"
    t.boolean "paid_in_usd", default: false
    t.decimal "service_price", precision: 10, scale: 2
    t.bigint "product_id", null: false
    t.decimal "amount", precision: 18, scale: 2, default: "0.0"
    t.decimal "amount_sold", precision: 18, scale: 2, default: "0.0"
    t.string "comment"
    t.integer "payment_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_from_counterparty_id"
    t.bigint "combination_of_local_product_id"
    t.boolean "local_entry", default: false
    t.boolean "return", default: false
    t.decimal "price_in_percentage", precision: 5, scale: 2
    t.index ["combination_of_local_product_id"], name: "index_product_entries_on_combination_of_local_product_id"
    t.index ["delivery_from_counterparty_id"], name: "index_product_entries_on_delivery_from_counterparty_id"
    t.index ["product_id"], name: "index_product_entries_on_product_id"
  end

  create_table "product_remaining_inequalities", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "amount"
    t.decimal "previous_amount"
    t.string "reason"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_remaining_inequalities_on_product_id"
    t.index ["user_id"], name: "index_product_remaining_inequalities_on_user_id"
  end

  create_table "product_sells", force: :cascade do |t|
    t.bigint "combination_of_local_product_id"
    t.bigint "product_id", null: false
    t.decimal "buy_price", precision: 16, scale: 2, default: "0.0"
    t.decimal "sell_price", precision: 16, scale: 2, default: "0.0"
    t.decimal "total_profit", default: "0.0"
    t.jsonb "price_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount", precision: 15, scale: 2, default: "0.0"
    t.jsonb "average_prices"
    t.bigint "sale_from_local_service_id"
    t.bigint "sale_id"
    t.bigint "sale_from_service_id"
    t.boolean "price_in_usd", default: false
    t.index ["combination_of_local_product_id"], name: "index_product_sells_on_combination_of_local_product_id"
    t.index ["product_id"], name: "index_product_sells_on_product_id"
    t.index ["sale_from_local_service_id"], name: "index_product_sells_on_sale_from_local_service_id"
    t.index ["sale_from_service_id"], name: "index_product_sells_on_sale_from_service_id"
    t.index ["sale_id"], name: "index_product_sells_on_sale_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.boolean "local", default: false
    t.boolean "active", default: true
    t.decimal "sell_price", precision: 14, scale: 2, default: "0.0"
    t.decimal "buy_price", precision: 14, scale: 2, default: "0.0"
    t.decimal "initial_remaining", precision: 15, scale: 2, default: "0.0"
    t.integer "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "price_in_usd", default: false
    t.string "code"
    t.boolean "for_sale", default: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "comment"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
  end

  create_table "salaries", force: :cascade do |t|
    t.boolean "prepayment"
    t.date "month", default: "2024-01-30"
    t.bigint "team_id"
    t.bigint "user_id"
    t.decimal "price", precision: 10, scale: 2
    t.integer "payment_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_salaries_on_team_id"
    t.index ["user_id"], name: "index_salaries_on_user_id"
  end

  create_table "sale_from_local_services", force: :cascade do |t|
    t.decimal "total_price", precision: 18, scale: 2, default: "0.0"
    t.decimal "total_paid", precision: 18, scale: 2
    t.string "coment"
    t.bigint "buyer_id", null: false
    t.integer "payment_type", default: 0
    t.integer "status", default: 0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_sale_from_local_services_on_buyer_id"
    t.index ["user_id"], name: "index_sale_from_local_services_on_user_id"
  end

  create_table "sale_from_services", force: :cascade do |t|
    t.decimal "total_paid", precision: 17, scale: 2, default: "0.0"
    t.integer "payment_type", default: 0
    t.bigint "buyer_id", null: false
    t.decimal "total_price", precision: 17, scale: 2, default: "0.0"
    t.string "comment"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_sale_from_services_on_buyer_id"
    t.index ["user_id"], name: "index_sale_from_services_on_user_id"
  end

  create_table "sale_product_increasers", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "amount", default: "1.0"
    t.bigint "user_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_product_increasers_on_product_id"
    t.index ["user_id"], name: "index_sale_product_increasers_on_user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.decimal "total_paid", precision: 17, scale: 2, default: "0.0"
    t.integer "payment_type", default: 0
    t.bigint "buyer_id", null: false
    t.decimal "total_price", precision: 17, scale: 2, default: "0.0"
    t.string "comment"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "price_in_usd", default: false
    t.boolean "enable_to_send_sms", default: true
    t.index ["buyer_id"], name: "index_sales_on_buyer_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.integer "unit"
    t.decimal "price", precision: 15, scale: 2, default: "0.0"
    t.boolean "active", default: true
    t.bigint "user_id", null: false
    t.integer "team_fee_in_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "storages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_services", force: :cascade do |t|
    t.bigint "sale_from_service_id", null: false
    t.bigint "team_id", null: false
    t.decimal "total_price", precision: 17, scale: 2, default: "0.0"
    t.integer "team_fee", default: 30
    t.decimal "team_portion", precision: 17, scale: 2, default: "0.0"
    t.decimal "company_portion", precision: 17, scale: 2, default: "0.0"
    t.bigint "user_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_from_service_id"], name: "index_team_services_on_sale_from_service_id"
    t.index ["team_id"], name: "index_team_services_on_team_id"
    t.index ["user_id"], name: "index_team_services_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.bigint "sale_id"
    t.bigint "sale_from_service_id"
    t.bigint "sale_from_local_service_id"
    t.bigint "delivery_from_counterparty_id"
    t.bigint "expenditure_id"
    t.decimal "price", precision: 17, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "price_in_usd", default: false
    t.bigint "user_id"
    t.boolean "first_record", default: false
    t.integer "payment_type", default: 0
    t.decimal "estimated_profit", precision: 17, scale: 2, default: "0.0"
    t.index ["delivery_from_counterparty_id"], name: "index_transaction_histories_on_delivery_from_counterparty_id"
    t.index ["expenditure_id"], name: "index_transaction_histories_on_expenditure_id"
    t.index ["sale_from_local_service_id"], name: "index_transaction_histories_on_sale_from_local_service_id"
    t.index ["sale_from_service_id"], name: "index_transaction_histories_on_sale_from_service_id"
    t.index ["sale_id"], name: "index_transaction_histories_on_sale_id"
    t.index ["user_id"], name: "index_transaction_histories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 2
    t.string "name"
    t.boolean "active", default: true
    t.boolean "allowed_to_use", default: true
    t.integer "daily_payment", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telegram_chat_id"
    t.string "string"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "currency_conversions", "users"
  add_foreign_key "daily_transaction_reports", "users"
  add_foreign_key "debt_operations", "debt_users"
  add_foreign_key "debt_operations", "users"
  add_foreign_key "delivery_from_counterparties", "product_categories"
  add_foreign_key "delivery_from_counterparties", "providers"
  add_foreign_key "delivery_from_counterparties", "users"
  add_foreign_key "discounts", "sales"
  add_foreign_key "discounts", "users"
  add_foreign_key "expenditures", "combination_of_local_products"
  add_foreign_key "expenditures", "delivery_from_counterparties"
  add_foreign_key "expenditures", "users"
  add_foreign_key "local_services", "sale_from_local_services"
  add_foreign_key "local_services", "users"
  add_foreign_key "owners_operations", "users"
  add_foreign_key "participations", "users"
  add_foreign_key "product_entries", "combination_of_local_products"
  add_foreign_key "product_entries", "delivery_from_counterparties"
  add_foreign_key "product_entries", "products"
  add_foreign_key "product_remaining_inequalities", "products"
  add_foreign_key "product_remaining_inequalities", "users"
  add_foreign_key "product_sells", "combination_of_local_products"
  add_foreign_key "product_sells", "products"
  add_foreign_key "product_sells", "sale_from_local_services"
  add_foreign_key "product_sells", "sale_from_services"
  add_foreign_key "product_sells", "sales"
  add_foreign_key "salaries", "teams"
  add_foreign_key "salaries", "users"
  add_foreign_key "sale_from_local_services", "buyers"
  add_foreign_key "sale_from_local_services", "users"
  add_foreign_key "sale_from_services", "buyers"
  add_foreign_key "sale_from_services", "users"
  add_foreign_key "sale_product_increasers", "products"
  add_foreign_key "sale_product_increasers", "users"
  add_foreign_key "sales", "buyers"
  add_foreign_key "sales", "users"
  add_foreign_key "services", "users"
  add_foreign_key "team_services", "sale_from_services"
  add_foreign_key "team_services", "teams"
  add_foreign_key "team_services", "users"
  add_foreign_key "transaction_histories", "delivery_from_counterparties"
  add_foreign_key "transaction_histories", "expenditures"
  add_foreign_key "transaction_histories", "sale_from_local_services"
  add_foreign_key "transaction_histories", "sale_from_services"
  add_foreign_key "transaction_histories", "sales"
  add_foreign_key "transaction_histories", "users"
end

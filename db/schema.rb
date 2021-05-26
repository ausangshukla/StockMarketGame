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

ActiveRecord::Schema.define(version: 2021_05_26_051638) do

  create_table "action_text_rich_texts", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "exchanges", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", limit: 20
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "news", charset: "utf8mb3", force: :cascade do |t|
    t.string "news_type", limit: 30
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_books", charset: "utf8mb3", force: :cascade do |t|
    t.string "symbol", limit: 20
    t.integer "security_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "exchange_id"
    t.index ["exchange_id"], name: "index_order_books_on_exchange_id"
    t.index ["security_id"], name: "index_order_books_on_security_id"
  end

  create_table "orders", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "side", limit: 5, null: false
    t.string "symbol", limit: 20, null: false
    t.integer "security_id", null: false
    t.integer "quantity", null: false
    t.float "price"
    t.string "price_type", limit: 10, null: false
    t.string "order_type", limit: 10, null: false
    t.string "qualifier", limit: 10
    t.integer "linked_short_cover_id"
    t.integer "filled_qty"
    t.integer "open_qty"
    t.string "status", limit: 10, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "fill_status", limit: 15
    t.index ["security_id"], name: "index_orders_on_security_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "securities", charset: "utf8mb3", force: :cascade do |t|
    t.string "sec_type", limit: 10, null: false
    t.string "symbol", limit: 20, null: false
    t.string "name", limit: 100, null: false
    t.float "prev_closing_price", default: 0.0
    t.float "opening_trade_price", default: 0.0
    t.float "day_high_price", default: 0.0
    t.float "day_low_price", default: 0.0
    t.float "price", default: 0.0
    t.bigint "market_cap", default: 0
    t.float "pe", default: 0.0
    t.datetime "last_trade_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["symbol"], name: "index_securities_on_symbol", unique: true
  end

  create_table "statements", charset: "utf8mb3", force: :cascade do |t|
    t.text "particulars"
    t.float "debit"
    t.float "credit"
    t.float "net"
    t.string "stmt_type", limit: 10
    t.integer "user_id"
    t.integer "ref_id"
    t.string "ref_type", limit: 30
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ref_id"], name: "index_statements_on_ref_id"
    t.index ["user_id"], name: "index_statements_on_user_id"
  end

  create_table "trades", charset: "utf8mb3", force: :cascade do |t|
    t.integer "buy_order_id", null: false
    t.string "symbol", limit: 20, null: false
    t.integer "security_id", null: false
    t.integer "quantity", null: false
    t.float "price", null: false
    t.integer "buyer_id", null: false
    t.integer "seller_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sell_order_id"
    t.index ["sell_order_id"], name: "index_trades_on_sell_order_id"
    t.index ["buy_order_id"], name: "index_trades_on_buy_order_id"
    t.index ["security_id"], name: "index_trades_on_security_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "first_name", limit: 80
    t.string "last_name", limit: 80
    t.string "role", limit: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.float "available_margin"
    t.float "used_margin"
    t.float "available_cash"
    t.float "opening_balance"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end

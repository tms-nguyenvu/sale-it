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

ActiveRecord::Schema[8.0].define(version: 2025_05_13_015117) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "industry"
    t.string "website"
    t.bigint "crawl_source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "funding_round"
    t.string "employee_count"
    t.string "hiring_roles_count"
    t.integer "potential_score"
    t.text "note"
    t.index ["crawl_source_id"], name: "index_companies_on_crawl_source_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name"
    t.string "email"
    t.string "position"
    t.string "phone_number"
    t.boolean "is_decision_maker"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
  end

  create_table "crawl_data_temporaries", force: :cascade do |t|
    t.jsonb "data"
    t.integer "data_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "crawl_source_id", null: false
    t.index ["crawl_source_id"], name: "index_crawl_data_temporaries_on_crawl_source_id"
  end

  create_table "crawl_sources", force: :cascade do |t|
    t.string "source_url"
    t.integer "source_type"
    t.text "description"
    t.integer "status"
    t.integer "approval_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "scheduled", default: false
  end

  create_table "email_replies", force: :cascade do |t|
    t.bigint "email_id", null: false
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.text "body"
    t.datetime "received_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_email_replies_on_contact_id"
    t.index ["email_id"], name: "index_email_replies_on_email_id"
    t.index ["user_id"], name: "index_email_replies_on_user_id"
  end

  create_table "email_suggestions", force: :cascade do |t|
    t.bigint "email_id", null: false
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_email_suggestions_on_email_id"
  end

  create_table "email_trackings", force: :cascade do |t|
    t.bigint "email_id", null: false
    t.datetime "clicked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_id"], name: "index_email_trackings_on_email_id"
  end

  create_table "emails", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.string "subject"
    t.text "body"
    t.integer "email_type"
    t.string "tone"
    t.datetime "sent_at", precision: nil
    t.integer "status"
    t.datetime "replied_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["contact_id"], name: "index_emails_on_contact_id"
    t.index ["user_id"], name: "index_emails_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.string "level"
    t.string "location"
    t.string "employment_type"
    t.string "tech_stack", default: [], array: true
    t.date "posted_date"
    t.string "application_url"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_jobs_on_company_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "companies", "crawl_sources"
  add_foreign_key "contacts", "companies"
  add_foreign_key "crawl_data_temporaries", "crawl_sources", on_delete: :cascade
  add_foreign_key "email_replies", "contacts"
  add_foreign_key "email_replies", "emails"
  add_foreign_key "email_replies", "users"
  add_foreign_key "email_suggestions", "emails"
  add_foreign_key "email_trackings", "emails"
  add_foreign_key "emails", "contacts"
  add_foreign_key "emails", "users"
  add_foreign_key "jobs", "companies"
end

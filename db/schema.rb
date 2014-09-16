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

ActiveRecord::Schema.define(version: 20140916161226) do

  create_table "conditions", force: true do |t|
    t.string   "text_status"
    t.string   "text"
    t.string   "system"
    t.string   "code"
    t.string   "code_text"
    t.string   "identifier_use"
    t.string   "identifier_label"
    t.string   "identifier_system"
    t.string   "identifier_value"
    t.string   "subject_reference"
    t.string   "subject_text"
    t.string   "encounter_reference"
    t.string   "encounter_text"
    t.string   "asserter_reference"
    t.string   "asserter_text"
    t.date     "date_asserted"
    t.string   "category_system"
    t.string   "category_code"
    t.string   "category_text"
    t.string   "status"
    t.string   "certainty_system"
    t.string   "certainty_code"
    t.string   "certainty_text"
    t.string   "severity_system"
    t.string   "severity_code"
    t.string   "severity_text"
    t.date     "onset_date"
    t.string   "onset_age_value"
    t.string   "onset_age_units"
    t.string   "onset_age_system"
    t.string   "onset_age_code"
    t.boolean  "abated"
    t.date     "abatement_date"
    t.string   "abatement_age_value"
    t.string   "abatement_age_units"
    t.string   "abatement_age_system"
    t.string   "abatement_age_code"
    t.string   "stage_system"
    t.string   "stage_code"
    t.string   "stage_text"
    t.string   "assessment_reference"
    t.string   "assessment_text"
    t.string   "evidence_system"
    t.string   "evidence_code"
    t.string   "evidence_text"
    t.string   "detail_reference"
    t.string   "detail_text"
    t.string   "location_system"
    t.string   "location_code"
    t.string   "location_text"
    t.string   "location_detail"
    t.string   "related_item_fhir_type"
    t.string   "related_item_system"
    t.string   "related_item_code"
    t.string   "related_item_text"
    t.string   "target_reference"
    t.string   "target_text"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id"
  end

  create_table "encounters", force: true do |t|
    t.string   "status"
    t.string   "enc_class"
    t.string   "enc_type"
    t.string   "participant"
    t.string   "participanttype"
    t.string   "start"
    t.string   "length"
    t.string   "priority"
    t.string   "location"
    t.string   "locationperiod"
    t.string   "serviceprovider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id"
  end

  create_table "medications", force: true do |t|
    t.string   "name"
    t.string   "system"
    t.string   "code"
    t.string   "text"
    t.boolean  "is_brand"
    t.string   "manufacturer_reference"
    t.string   "manufacturer_text"
    t.string   "kind"
    t.string   "product_form_system"
    t.string   "product_form_code"
    t.string   "product_form_text"
    t.string   "product_ingredient_item_reference"
    t.string   "product_ingredient_item_text"
    t.string   "package_container_system"
    t.string   "package_container_code"
    t.string   "package_container_text"
    t.string   "package_content_item_reference"
    t.string   "package_content_item_text"
    t.string   "package_content_amount_value"
    t.string   "package_content_units"
    t.string   "package_content_system"
    t.string   "package_content_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id"
  end

  create_table "observations", force: true do |t|
    t.string   "name"
    t.string   "obs_type"
    t.string   "value"
    t.string   "interpretation"
    t.string   "comments"
    t.string   "issued"
    t.string   "period"
    t.string   "status"
    t.string   "reliability"
    t.string   "bodysite"
    t.string   "methodcode"
    t.string   "methodtext"
    t.string   "performer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_id"
    t.integer  "encounter_id"
  end

  create_table "patients", force: true do |t|
    t.string   "givenname"
    t.string   "familyname"
    t.string   "gender"
    t.string   "birthdate"
    t.string   "telecom"
    t.string   "address"
    t.boolean  "isdeceased"
    t.string   "maritalstatus"
    t.string   "outsidecontact"
    t.string   "outsidecontacttelecom"
    t.string   "outsidecontactaddress"
    t.string   "primarylanguage"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end

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

ActiveRecord::Schema.define(version: 20131003175551) do

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

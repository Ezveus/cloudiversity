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

ActiveRecord::Schema.define(version: 20140405184708) do

  create_table "disciplines", force: true do |t|
    t.string "name"
  end

  create_table "school_classes", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.integer  "school_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teacher_school_class_disciplines", force: true do |t|
    t.integer "teacher_id"
    t.integer "school_class_id"
    t.integer "discipline_id"
  end

  add_index "teacher_school_class_disciplines", ["discipline_id"], name: "index_teacher_school_class_disciplines_on_discipline_id"
  add_index "teacher_school_class_disciplines", ["school_class_id"], name: "index_teacher_school_class_disciplines_on_school_class_id"
  add_index "teacher_school_class_disciplines", ["teacher_id"], name: "index_teacher_school_class_disciplines_on_teacher_id"

  create_table "teachers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login",                default: "", null: false
    t.string   "email",                default: "", null: false
    t.string   "encrypted_password",   default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",      default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",           default: "", null: false
    t.string   "last_name",            default: "", null: false
    t.integer  "school_class_id"
    t.integer  "role_id"
    t.string   "role_type"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["login"], name: "index_users_on_login", unique: true
  add_index "users", ["role_id", "role_type"], name: "index_users_on_role_id_and_role_type"
  add_index "users", ["school_class_id"], name: "index_users_on_school_class_id"
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end

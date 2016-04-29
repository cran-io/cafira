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

ActiveRecord::Schema.define(version: 20160429204429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "aditional_services", force: :cascade do |t|
    t.boolean  "energia",                  default: false
    t.integer  "energia_cantidad"
    t.boolean  "estacionamiento",          default: false
    t.integer  "estacionamiento_cantidad"
    t.boolean  "nylon",                    default: false
    t.boolean  "cuotas_sociales",          default: false
    t.integer  "catalogo_extra_cantidad"
    t.boolean  "catalogo_extra",           default: false
    t.integer  "coutas_sociales_cantidad"
    t.integer  "expositor_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "completed",                default: false
  end

  create_table "blueprint_files", force: :cascade do |t|
    t.integer  "state"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "infrastructure_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "comment"
  end

  create_table "catalog_images", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "priority"
    t.integer  "catalog_id"
    t.boolean  "valid_image"
  end

  create_table "catalogs", force: :cascade do |t|
    t.string   "stand_number"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "type"
    t.integer  "expositor_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "completed",              default: false
    t.text     "description"
    t.string   "phone_number"
    t.string   "aditional_phone_number"
    t.string   "email"
    t.string   "aditional_email"
    t.string   "website"
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "zip_code"
    t.text     "comment"
    t.integer  "state",                  default: 3
    t.string   "fantasy_name"
    t.string   "catalog_type"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "architect_id"
    t.integer  "blueprint_file_id"
    t.text     "comment"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "who_created"
  end

  create_table "credentials", force: :cascade do |t|
    t.string   "name"
    t.boolean  "armador",        default: false
    t.boolean  "personal_stand", default: false
    t.boolean  "foto_video",     default: false
    t.integer  "expositor_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "art",            default: false
    t.boolean  "es_expositor",   default: false
    t.date     "fecha_alta"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "exposition_expositors", force: :cascade do |t|
    t.integer  "exposition_id"
    t.integer  "expositor_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "exposition_files", force: :cascade do |t|
    t.string   "file_type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "exposition_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "expositions", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",                      default: false
    t.date     "initialized_at"
    t.date     "ends_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.date     "deadline_catalogs"
    t.date     "deadline_credentials"
    t.date     "deadline_aditional_services"
    t.date     "deadline_infrastructures"
    t.integer  "days_to_notify_deadlines"
  end

  create_table "infrastructures", force: :cascade do |t|
    t.boolean  "tarima",        default: false
    t.boolean  "paneles",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "expositor_id"
    t.boolean  "completed",     default: false
    t.string   "alfombra_tipo"
    t.boolean  "alfombra",      default: false
  end

  create_table "massive_mails", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "campaign"
    t.boolean  "sent",                    default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "cuit"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

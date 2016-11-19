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

ActiveRecord::Schema.define(version: 20160803045831) do

  create_table "enquiries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       limit: 128,                      null: false
    t.string   "email",      limit: 256,                      null: false
    t.string   "phone",      limit: 24,                       null: false
    t.string   "subject",    limit: 256,                      null: false
    t.text     "message",    limit: 65535
    t.string   "status",     limit: 16,    default: "unread", null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",           limit: 512,                           null: false
    t.string   "permalink",       limit: 32,                            null: false
    t.string   "venue",           limit: 256,                           null: false
    t.text     "description",     limit: 65535
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "status",          limit: 16,    default: "unpublished", null: false
    t.string   "facebook_url",    limit: 256
    t.string   "twitter_url",     limit: 256
    t.string   "google_plus_url", limit: 256
    t.string   "linkedin_url",    limit: 256
    t.string   "instagram_url",   limit: 256
    t.string   "pinterest_url",   limit: 256
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree
  end

  create_table "models", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",         limit: 128,                      null: false
    t.string   "permalink",    limit: 128,                      null: false
    t.text     "description1", limit: 65535
    t.text     "description2", limit: 65535
    t.text     "description3", limit: 65535
    t.text     "description4", limit: 65535
    t.string   "nationality"
    t.boolean  "featured",                   default: false
    t.string   "status",       limit: 16,    default: "active", null: false
    t.string   "height"
    t.string   "weight"
    t.string   "bust"
    t.string   "waist"
    t.string   "hips"
    t.string   "shoe"
    t.string   "eyes"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "subscriptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",      limit: 256, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "testimonials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",         limit: 128,                           null: false
    t.string   "designation",  limit: 256,                           null: false
    t.string   "organisation", limit: 256,                           null: false
    t.text     "statement",    limit: 65535
    t.string   "status",       limit: 16,    default: "unpublished", null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                   limit: 256
    t.string   "username",               limit: 32,                       null: false
    t.string   "email",                  limit: 256,                      null: false
    t.string   "phone",                  limit: 24
    t.string   "designation",            limit: 56
    t.boolean  "super_admin",                        default: false
    t.string   "status",                 limit: 16,  default: "inactive", null: false
    t.string   "password_digest",                                         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "auth_token"
    t.datetime "token_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

end

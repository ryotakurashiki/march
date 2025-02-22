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

ActiveRecord::Schema.define(version: 20161007004158) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "appearance_artists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.integer  "artist_id"
    t.string   "setlist_path"
    t.boolean  "not_decided",     default: false
    t.integer  "creator_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["attachable_id", "attachable_type", "artist_id"], name: "appearance_artist_unique", unique: true, using: :btree
  end

  create_table "artist_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "artist_id"
    t.integer  "related_artist_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "related_eplus_artist_id"
    t.index ["artist_id", "related_eplus_artist_id"], name: "index_artist_relations_on_artist_id_and_related_eplus_artist_id", unique: true, using: :btree
  end

  create_table "artists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "category"
    t.integer  "creator_id"
    t.boolean  "admin_denied", default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "kana_done",    default: false
    t.index ["name"], name: "index_artists_on_name", unique: true, using: :btree
  end

  create_table "concerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "place"
    t.integer  "prefecture_id"
    t.date     "date"
    t.integer  "category"
    t.string   "eplus_id"
    t.string   "livefans_path"
    t.integer  "creator_id"
    t.boolean  "self_planed",   default: false
    t.boolean  "title_edited",  default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["title", "place", "date"], name: "index_concerts_on_title_and_place_and_date", unique: true, using: :btree
  end

  create_table "crawl_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "status"
    t.integer  "error_count",                             default: 0
    t.text     "error_message",             limit: 65535
    t.integer  "priority"
    t.datetime "crawled_on"
    t.integer  "medium_artist_relation_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "deactive_concerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "place"
    t.integer  "prefecture_id"
    t.date     "date"
    t.string   "category"
    t.string   "eplus_id"
    t.boolean  "self_planed",     default: false
    t.string   "date_text"
    t.boolean  "active",          default: false
    t.boolean  "eplus_id_edited", default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["title", "place", "date_text"], name: "index_deactive_concerts_on_title_and_place_and_date_text", using: :btree
  end

  create_table "favorite_artists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "artist_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "artist_id"], name: "index_favorite_artists_on_user_id_and_artist_id", unique: true, using: :btree
  end

  create_table "favorite_prefectures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "prefecture_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["user_id", "prefecture_id"], name: "index_favorite_prefectures_on_user_id_and_prefecture_id", unique: true, using: :btree
  end

  create_table "kanas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "artist_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id", "name"], name: "index_kanas_on_artist_id_and_name", unique: true, using: :btree
  end

  create_table "media", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "en_name"
    t.string   "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medium_artist_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "medium_id"
    t.integer  "artist_id"
    t.string   "medium_artist_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["medium_id", "artist_id", "medium_artist_id"], name: "artist_relations_uniq", unique: true, using: :btree
  end

  create_table "prefectures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_prefectures_on_name", unique: true, using: :btree
  end

  create_table "tickets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "info",               limit: 65535
    t.integer  "concert_id"
    t.integer  "medium_id"
    t.string   "medium_ticket_id"
    t.string   "ticket_path"
    t.text     "seat",               limit: 65535
    t.string   "number_of_tickets"
    t.boolean  "selling_separately",               default: false
    t.integer  "price"
    t.string   "remaining_time"
    t.boolean  "extra_payment"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["medium_id", "medium_ticket_id"], name: "index_tickets_on_medium_id_and_medium_ticket_id", unique: true, using: :btree
  end

  create_table "user_concert_joinings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "concert_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "concert_id"], name: "index_user_concert_joinings_on_user_id_and_concert_id", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.string   "username",               limit: 16, default: "",    null: false
    t.string   "username_jp",            limit: 21, default: "なまえ"
    t.string   "icon"
    t.string   "icon_tw"
    t.string   "description"
    t.boolean  "tutorial_finished"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "watched_artists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "appearance_artist_id"
    t.integer  "user_concert_joining_id"
    t.boolean  "watched"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["appearance_artist_id", "user_concert_joining_id"], name: "appearance_artist_user_unique", unique: true, using: :btree
  end

end

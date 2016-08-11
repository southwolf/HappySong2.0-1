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

ActiveRecord::Schema.define(version: 20160810051422) do

  create_table "advises", force: :cascade do |t|
    t.string   "content",    limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact",    limit: 255
  end

  create_table "albums", force: :cascade do |t|
    t.string   "file_url",   limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_grades", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_sections", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "author",     limit: 255
    t.string   "content",    limit: 255
    t.integer  "article_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "cover_img",        limit: 255
    t.integer  "subject_id",       limit: 4
    t.integer  "article_grade_id", limit: 4
    t.integer  "edition_id",       limit: 4
    t.integer  "unit_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author",           limit: 255
    t.integer  "records_count",    limit: 4
    t.boolean  "is_demo",                      default: false
  end

  create_table "articles_cate_items", id: false, force: :cascade do |t|
    t.integer "cate_item_id", limit: 4
    t.integer "article_id",   limit: 4
  end

  create_table "banners", force: :cascade do |t|
    t.string   "cover_img",  limit: 255
    t.string   "text",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cate_items", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "province_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "content",          limit: 255
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root_id",          limit: 4
    t.integer  "user_id",          limit: 4
  end

  create_table "districts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "city_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "editions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grade_join_schools", force: :cascade do |t|
    t.integer "grade_id",  limit: 4
    t.integer "school_id", limit: 4
  end

  add_index "grade_join_schools", ["grade_id", "school_id"], name: "index_grade_join_schools_on_grade_id_and_school_id", using: :btree

  create_table "grade_team_classes", force: :cascade do |t|
    t.string  "code",          limit: 255
    t.integer "grade_id",      limit: 4
    t.integer "team_class_id", limit: 4
    t.integer "user_id",       limit: 4
    t.integer "school_id",     limit: 4
  end

  create_table "grades", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "like_user_id",  limit: 4
    t.integer  "likeable_id",   limit: 4
    t.string   "likeable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "music_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "musics", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "file_url",      limit: 255
    t.integer  "music_type_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "records_count", limit: 4
  end

  create_table "provinces", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", force: :cascade do |t|
    t.string   "file_url",   limit: 255
    t.string   "feeling",    limit: 255
    t.string   "style",      limit: 255
    t.integer  "user_id",    limit: 4
    t.integer  "article_id", limit: 4
    t.integer  "music_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public"
    t.integer  "view_count", limit: 4
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id",  limit: 4
    t.integer  "following_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["follower_id", "following_id"], name: "index_relationships_on_follower_id_and_following_id", using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
  add_index "relationships", ["following_id"], name: "index_relationships_on_following_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "district_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools_team_classes", id: false, force: :cascade do |t|
    t.integer "school_id",     limit: 4
    t.integer "team_class_id", limit: 4
  end

  add_index "schools_team_classes", ["school_id", "team_class_id"], name: "index_schools_team_classes_on_school_id_and_team_class_id", using: :btree

  create_table "smart_sms_messages", force: :cascade do |t|
    t.string   "sid",               limit: 255
    t.string   "mobile",            limit: 255
    t.datetime "send_time"
    t.text     "text",              limit: 65535
    t.string   "code",              limit: 255
    t.string   "send_status",       limit: 255
    t.string   "report_status",     limit: 255
    t.string   "fee",               limit: 255
    t.datetime "user_receive_time"
    t.text     "error_msg",         limit: 65535
    t.integer  "smsable_id",        limit: 4
    t.string   "smsable_type",      limit: 255
    t.string   "uid",               limit: 255
  end

  add_index "smart_sms_messages", ["sid"], name: "index_smart_sms_messages_on_sid", using: :btree
  add_index "smart_sms_messages", ["smsable_id", "smsable_type"], name: "index_smart_sms_messages_on_smsable_id_and_smsable_type", using: :btree
  add_index "smart_sms_messages", ["uid"], name: "index_smart_sms_messages_on_uid", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_class_users", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "team_class_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_class_users", ["team_class_id"], name: "index_team_class_users_on_team_class_id", using: :btree
  add_index "team_class_users", ["user_id", "team_class_id"], name: "index_team_class_users_on_user_id_and_team_class_id", using: :btree
  add_index "team_class_users", ["user_id"], name: "index_team_class_users_on_user_id", using: :btree

  create_table "team_classes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "phone",      limit: 255
    t.string   "name",       limit: 255
    t.string   "uid",        limit: 255
    t.string   "avatar",     limit: 255, default: "happysong_logo.jpg"
    t.string   "sex",        limit: 255
    t.integer  "age",        limit: 4
    t.string   "desc",       limit: 255
    t.boolean  "vip",                    default: false
    t.boolean  "is_first",               default: true
    t.string   "code",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token", limit: 255
    t.integer  "role_id",    limit: 4
  end

end

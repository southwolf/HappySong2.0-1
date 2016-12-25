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

ActiveRecord::Schema.define(version: 20161225102831) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "email"
    t.string   "phone",           limit: 20
  end

  create_table "advises", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact"
  end

  create_table "albums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "file_url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apply_cash_backs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "channel_user_id"
    t.integer  "amount"
    t.string   "alipay"
    t.boolean  "passed",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_grades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "article_id"
    t.integer  "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_works_on_article_id", using: :btree
    t.index ["work_id"], name: "index_article_works_on_work_id", using: :btree
  end

  create_table "articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "title"
    t.string   "cover_img"
    t.text     "content",          limit: 65535,                 null: false
    t.integer  "subject_id"
    t.integer  "article_grade_id"
    t.integer  "edition_id"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author",                         default: "佚名"
    t.integer  "records_count",                  default: 0
    t.boolean  "has_demo",                       default: false
    t.boolean  "is_hot",                         default: false
    t.boolean  "article_type",                   default: true
  end

  create_table "articles_cate_items", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer "cate_item_id"
    t.integer "article_id"
  end

  create_table "associators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.date     "start_time"
    t.date     "expire_time"
    t.string   "type"
    t.integer  "student_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["student_id"], name: "index_associators_on_student_id", using: :btree
  end

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "dynamic_id"
    t.boolean  "is_video",   default: false
    t.string   "file_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "cover_img"
    t.string   "text"
    t.integer  "targetable_id"
    t.string   "targetable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_url"
  end

  create_table "bills", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.integer  "amount"
    t.string   "bill_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete",       default: false
    t.string   "order_no"
    t.string   "channel"
    t.string   "client_ip"
    t.string   "charge_id"
  end

  create_table "cash_backs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "cash",       default: 0
    t.integer  "used",       default: 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "amount",         default: 0
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cate_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channel_schools", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "channel_user_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "passed",          default: false
    t.string   "reason"
  end

  create_table "channel_user_cash_backs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "channel_user_id"
    t.integer  "amount",          default: 0
    t.integer  "used",            default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "channel_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password_digest"
    t.boolean  "company",         default: false
    t.string   "phone"
    t.string   "token"
    t.boolean  "admin",           default: false
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alipay"
    t.string   "status"
  end

  create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "class_id"
    t.integer  "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_id"], name: "index_class_students_on_class_id", using: :btree
    t.index ["student_id"], name: "index_class_students_on_student_id", using: :btree
  end

  create_table "class_works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "class_id"
    t.integer  "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_id"], name: "index_class_works_on_class_id", using: :btree
    t.index ["work_id"], name: "index_class_works_on_work_id", using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT" do |t|
    t.text     "content",          limit: 65535
    t.integer  "commentable_id"
    t.string   "commentable_type",                               collation: "utf8_unicode_ci"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root_id"
    t.integer  "user_id"
    t.integer  "top_comment_id"
    t.boolean  "is_reply",                       default: false
  end

  create_table "configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.integer  "point"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "point",      default: 0
    t.integer  "used",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "districts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "do_works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "student_work_id"
    t.string   "content"
    t.string   "type"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "article_id"
    t.string   "avatar"
    t.index ["article_id"], name: "index_do_works_on_article_id", using: :btree
    t.index ["student_work_id"], name: "index_do_works_on_student_work_id", using: :btree
    t.index ["user_id"], name: "index_do_works_on_user_id", using: :btree
  end

  create_table "dynamics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.text     "content",             limit: 65535
    t.string   "address",                                           collation: "utf8_unicode_ci"
    t.boolean  "is_relay",                          default: false
    t.integer  "original_dynamic_id"
    t.integer  "root_dynamic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",                       default: 0
    t.integer  "comments_count",                    default: 0
    t.boolean  "is_work",                           default: false
    t.integer  "work_id"
  end

  create_table "editions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grade_join_schools", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer "grade_id"
    t.integer "school_id"
    t.index ["grade_id", "school_id"], name: "index_grade_join_schools_on_grade_id_and_school_id", using: :btree
  end

  create_table "grade_team_classes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "code"
    t.integer  "grade_id"
    t.integer  "team_class_id"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
  end

  create_table "grades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "teacher_id"
    t.string   "type",       limit: 15
    t.datetime "end_time"
    t.datetime "start_time"
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "avatar"
    t.index ["teacher_id"], name: "index_home_works_on_teacher_id", using: :btree
  end

  create_table "invites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.integer  "cash_back_count", default: 0
    t.boolean  "is_student",      default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "like_user_id"
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "materialable_id"
    t.string   "materialable_type", limit: 40
    t.string   "kind",              limit: 20,              comment: "Vidio | Image | Sound"
    t.string   "url"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.integer  "start_time"
    t.integer  "expire_time"
    t.string   "member_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "music_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "musics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.string   "file_url"
    t.integer  "music_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "records_count", default: 0
    t.string   "cover_img"
    t.string   "author"
  end

  create_table "nations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.integer  "admin_code"
    t.integer  "code"
    t.integer  "tag"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "new_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "actor_id"
    t.integer  "index"
    t.integer  "targetable_id"
    t.string   "targetable_type", limit: 40
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["actor_id"], name: "index_new_notifications_on_actor_id", using: :btree
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "notice_type",                           null: false
    t.integer  "actor_id"
    t.integer  "user_id"
    t.integer  "targetable_id"
    t.string   "targetable_type"
    t.integer  "second_targetable_id"
    t.string   "second_targetable_type"
    t.integer  "third_targetable_id"
    t.string   "third_targetable_type"
    t.boolean  "unread",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["actor_id"], name: "index_notifications_on_actor_id", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "notify_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.integer  "push_action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "org_classes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.integer  "school_id"
    t.integer  "grade_no"
    t.integer  "class_no"
    t.string   "code",                    comment: "班级码"
    t.integer  "teacher_id",              comment: "班主任ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_org_classes_on_code", length: {"code"=>191}, using: :btree
    t.index ["school_id"], name: "index_org_classes_on_school_id", using: :btree
    t.index ["teacher_id"], name: "index_org_classes_on_teacher_id", using: :btree
  end

  create_table "org_schools", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.integer  "nation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nation_id"], name: "index_org_schools_on_nation_id", using: :btree
  end

  create_table "provinces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "push_actions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT" do |t|
    t.string   "file_url",                                     collation: "utf8_unicode_ci"
    t.text     "feeling",        limit: 65535
    t.string   "style",                                        collation: "utf8_unicode_ci"
    t.integer  "user_id"
    t.integer  "article_id"
    t.integer  "music_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",                    default: true
    t.integer  "view_count",                   default: 0
    t.integer  "likes_count",                  default: 0
    t.boolean  "is_demo",                      default: false
    t.boolean  "is_hot",                       default: false
    t.integer  "comments_count",               default: 0
    t.boolean  "is_work",                      default: false
    t.integer  "work_id"
  end

  create_table "relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "follower_id"
    t.integer  "following_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["follower_id", "following_id"], name: "index_relationships_on_follower_id_and_following_id", using: :btree
    t.index ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
    t.index ["following_id"], name: "index_relationships_on_following_id", using: :btree
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.integer  "reportable_id"
    t.string   "reportable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools_team_classes", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer "school_id"
    t.integer "team_class_id"
    t.index ["school_id", "team_class_id"], name: "index_schools_team_classes_on_school_id_and_team_class_id", using: :btree
  end

  create_table "sms_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "code",         limit: 10
    t.integer  "user_id"
    t.datetime "invalid_time"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "student_works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "student_id"
    t.integer  "work_id"
    t.integer  "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_student_works_on_student_id", using: :btree
    t.index ["work_id"], name: "index_student_works_on_work_id", using: :btree
  end

  create_table "subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "dynamic_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "recommend",  default: false
    t.string   "cover_img"
    t.integer  "tag_heat",   default: 0
  end

  create_table "team_classes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "transfer_user_id"
    t.integer  "collector_id"
    t.string   "amount"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "units", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.string   "phone"
    t.string   "name"
    t.string   "uid"
    t.string   "avatar",                         default: "happysong_logo.jpg"
    t.string   "sex"
    t.string   "age"
    t.string   "desc"
    t.boolean  "vip",                            default: false
    t.boolean  "is_first",                       default: true
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.integer  "role_id"
    t.integer  "grade_team_class_id"
    t.integer  "credit_id"
    t.integer  "parent_id"
    t.string   "bg_image_url",                   default: "bg_image.png"
    t.string   "type",                limit: 20,                                comment: "User Role(Type)"
    t.string   "sms_code",            limit: 10
  end

  create_table "views", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "viewer_id"
    t.integer  "view_record_id"
    t.integer  "num",            default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "withdraw_cashes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.string   "alipay"
    t.integer  "amount"
    t.boolean  "passed",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "work_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "work_id"
    t.boolean  "is_video"
    t.string   "file_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_to_articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "article_id"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_to_students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "work_id"
    t.integer  "student_id"
    t.boolean  "complete",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_to_teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT" do |t|
    t.integer  "work_id"
    t.integer  "grade_team_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "works", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT" do |t|
    t.integer  "user_id"
    t.text     "content",        limit: 65535
    t.string   "style",                                    collation: "utf8_unicode_ci"
    t.integer  "comments_count",               default: 0
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

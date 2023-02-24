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

ActiveRecord::Schema.define(version: 2022_12_26_024209) do

  create_table "announcements", charset: "latin1", force: :cascade do |t|
    t.string "subject", null: false
    t.text "details"
    t.string "link_text"
    t.string "url"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean "always_show", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["start_at", "end_at"], name: "index_announcements_on_start_at_and_end_at"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.bigint "user_id", null: false
    t.bigint "parent_id"
    t.text "body", size: :medium
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["tournament_id"], name: "index_comments_on_tournament_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "competitors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.bigint "entity_id", null: false
    t.integer "seed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "annotation", limit: 50
    t.index ["entity_id"], name: "index_competitors_on_entity_id"
    t.index ["tournament_id"], name: "index_competitors_on_tournament_id"
  end

  create_table "contests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.integer "round", null: false
    t.integer "sort", null: false
    t.bigint "upper_id"
    t.bigint "lower_id"
    t.bigint "winner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lower_id"], name: "index_contests_on_lower_id"
    t.index ["tournament_id", "round", "sort"], name: "index_contests_on_tournament_id_and_round_and_sort"
    t.index ["tournament_id"], name: "index_contests_on_tournament_id"
    t.index ["upper_id"], name: "index_contests_on_upper_id"
    t.index ["winner_id"], name: "index_contests_on_winner_id"
  end

  create_table "delayed_jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", size: :medium, null: false
    t.text "last_error", size: :medium
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "entities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "path", null: false
    t.text "url", size: :medium
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "annotation", limit: 50
    t.index ["name"], name: "index_entities_on_name", length: 20
    t.index ["path"], name: "index_entities_on_path", length: 20
  end

  create_table "external_links", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.column "owner_type", "enum('Competitor','Entity','Tournament')", limit: ["Competitor", "Entity", "Tournament"], null: false
    t.bigint "owner_id", null: false
    t.column "type", "enum('Other','YouTube','Amazon','Image','Video')", limit: ["Other", "YouTube", "Amazon", "Image", "Video"], default: "Other", null: false
    t.string "short_code"
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_type", "owner_id"], name: "index_external_links_on_owner_type_and_owner_id"
  end

  create_table "settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.column "comments_status", "enum('disabled','enabled','read-only')", limit: ["disabled", "enabled", "read-only"], default: "disabled", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "short_codes", charset: "latin1", force: :cascade do |t|
    t.string "code", limit: 6, null: false
    t.column "resource_type", "enum('Tournament','Entity','User','Competitor')", limit: ["Tournament", "Entity", "User", "Competitor"], null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["resource_type", "resource_id"], name: "index_short_codes_on_resource_type_and_resource_id"
  end

  create_table "tournaments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "round_duration", default: 86400, null: false
    t.datetime "start_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.column "status", "enum('Building','Seeding','Pending','Active','Closed')", limit: ["Building", "Seeding", "Pending", "Active", "Closed"], default: "Building", null: false
    t.bigint "owner_id"
    t.boolean "featured", default: false, null: false
    t.column "visibility", "enum('Can Feature','Public','Private')", limit: ["Can Feature", "Public", "Private"], default: "Can Feature", null: false
    t.text "notes"
    t.column "comments_status", "enum('disabled','enabled','read-only')", limit: ["disabled", "enabled", "read-only"], default: "enabled", null: false
    t.bigint "based_on_id"
    t.index ["based_on_id"], name: "index_tournaments_on_based_on_id"
    t.index ["name"], name: "index_tournaments_on_name", length: 20
    t.index ["owner_id"], name: "index_tournaments_on_owner_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uid", limit: 100
    t.string "login_code", limit: 12
    t.column "provider", "enum('uuid','email')", limit: ["uuid", "email"], default: "uuid", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token", limit: 100
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token", limit: 100
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "username", limit: 20
    t.string "email", limit: 100
    t.text "tokens"
    t.string "instagram_handle"
    t.string "twitter_handle"
    t.boolean "daily_reminder", default: false, null: false
    t.column "role", "enum('Normal','Admin')", limit: ["Normal", "Admin"], default: "Normal", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "videos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "subject", null: false
    t.string "youtube_id", limit: 20, null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean "always_show", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["start_at", "end_at"], name: "index_videos_on_start_at_and_end_at"
  end

  create_table "votes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "contest_id", null: false
    t.bigint "competitor_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["competitor_id"], name: "index_votes_on_competitor_id"
    t.index ["contest_id"], name: "index_votes_on_contest_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "tournaments"
  add_foreign_key "comments", "users"
  add_foreign_key "competitors", "entities"
  add_foreign_key "competitors", "tournaments", on_delete: :cascade
  add_foreign_key "contests", "competitors", column: "lower_id"
  add_foreign_key "contests", "competitors", column: "upper_id"
  add_foreign_key "contests", "competitors", column: "winner_id"
  add_foreign_key "tournaments", "tournaments", column: "based_on_id"
  add_foreign_key "tournaments", "users", column: "owner_id"
  add_foreign_key "votes", "competitors"
  add_foreign_key "votes", "contests"
  add_foreign_key "votes", "users"
end

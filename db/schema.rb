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

ActiveRecord::Schema.define(version: 2022_07_30_174648) do

  create_table "competitors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.bigint "entity_id", null: false
    t.integer "seed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["name"], name: "index_entities_on_name", length: 20
    t.index ["path"], name: "index_entities_on_path", length: 20
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
    t.index ["name"], name: "index_tournaments_on_name", length: 20
    t.index ["owner_id"], name: "index_tournaments_on_owner_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid", limit: 36
    t.string "login_code", limit: 12
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

  add_foreign_key "competitors", "entities"
  add_foreign_key "competitors", "tournaments", on_delete: :cascade
  add_foreign_key "contests", "competitors", column: "lower_id"
  add_foreign_key "contests", "competitors", column: "upper_id"
  add_foreign_key "contests", "competitors", column: "winner_id"
  add_foreign_key "tournaments", "users", column: "owner_id"
  add_foreign_key "votes", "competitors"
  add_foreign_key "votes", "contests"
  add_foreign_key "votes", "users"
end

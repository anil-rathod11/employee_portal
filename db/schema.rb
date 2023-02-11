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

ActiveRecord::Schema[7.0].define(version: 2023_02_06_101819) do
  create_table "annual_summaries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "year"
    t.text "accumplishment"
    t.text "development_need"
    t.text "career_goals"
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_annual_summaries_on_employee_id"
  end

  create_table "annual_summary_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "annual_summary_id", null: false
    t.text "accumplishment_by_reviewer"
    t.text "development_need_by_reviewer"
    t.text "career_goals_by_reviewer"
    t.bigint "reviewer_id", null: false
    t.string "designation"
    t.string "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["annual_summary_id"], name: "index_annual_summary_remarks_on_annual_summary_id"
    t.index ["reviewer_id"], name: "index_annual_summary_remarks_on_reviewer_id"
  end

  create_table "empleaves", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.text "reason"
    t.date "start_date"
    t.date "end_date"
    t.float "no_of_paid_leave"
    t.string "status", default: "Pending"
    t.boolean "half_day", default: false
    t.boolean "wfh", default: false
    t.float "remaining_leaves"
    t.boolean "self", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id", "start_date"], name: "index_empleaves_on_employee_id_and_start_date", unique: true
    t.index ["employee_id"], name: "index_empleaves_on_employee_id"
  end

  create_table "employee_addresses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.integer "pincode"
    t.boolean "is_temp_or_permnt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country", default: "India"
    t.index ["employee_id"], name: "index_employee_addresses_on_employee_id"
  end

  create_table "employee_education_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "degree"
    t.integer "year"
    t.string "college_name"
    t.string "university_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "state"
    t.index ["employee_id"], name: "index_employee_education_details_on_employee_id"
  end

  create_table "employee_financial_infos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "PAN_no"
    t.string "UAN_no"
    t.string "bank_ac_no"
    t.string "bank_name"
    t.string "IFSC_code"
    t.string "branch_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_financial_infos_on_employee_id"
  end

  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "role"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.bigint "associated_manager_id"
    t.date "date_of_birth"
    t.string "aadhar_no"
    t.string "passport_no"
    t.string "visa_status"
    t.date "date_of_joining"
    t.string "emer_cont_name"
    t.string "emer_cont_no"
    t.string "altr_emer_cont_name"
    t.string "altr_emer_cont_no"
    t.string "blood_group"
    t.string "salut"
    t.bigint "project_id"
    t.string "designation"
    t.index ["associated_manager_id"], name: "index_employees_on_associated_manager_id"
    t.index ["project_id"], name: "index_employees_on_project_id"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "start_datetime", precision: nil
    t.datetime "end_datetime", precision: nil
    t.string "status", default: "Active"
    t.boolean "archive", default: false
    t.string "organized_for"
    t.bigint "project_id"
    t.bigint "individual_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_events_on_employee_id"
    t.index ["individual_id"], name: "index_events_on_individual_id"
    t.index ["project_id"], name: "index_events_on_project_id"
  end

  create_table "histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "year"
    t.string "quarter"
    t.string "summary"
    t.string "event"
    t.bigint "employee_id", null: false
    t.integer "associated_manager"
    t.datetime "submitted_date"
    t.boolean "archive", default: false
    t.boolean "annual_flag", default: false
    t.string "submitted_by"
    t.index ["employee_id"], name: "index_histories_on_employee_id"
  end

  create_table "leave_counters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.float "leaves"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_leave_counters_on_employee_id"
    t.index ["employee_id"], name: "index_leave_counters_on_employee_id_and_year", unique: true
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "team_size"
    t.bigint "project_lead_id"
    t.text "additional_requirement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_lead_id"], name: "index_projects_on_project_lead_id"
  end

  create_table "quarterly_appraisal_remarks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "quarterly_appraisal_id", null: false
    t.string "quarterly_summary_by_reviewer"
    t.bigint "reviewer_id", null: false
    t.string "designation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["quarterly_appraisal_id"], name: "index_quarterly_appraisal_remarks_on_quarterly_appraisal_id"
    t.index ["reviewer_id"], name: "index_quarterly_appraisal_remarks_on_reviewer_id"
  end

  create_table "quarterly_appraisals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "quarter"
    t.integer "year"
    t.bigint "employee_id", null: false
    t.text "quarterly_summary"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "archive", default: false
    t.index ["employee_id", "quarter", "year"], name: "index_quarterly_appraisals_on_employee_id_and_quarter_and_year", unique: true
    t.index ["employee_id"], name: "index_quarterly_appraisals_on_employee_id"
  end

  create_table "resignation_tables", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.text "resignation_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_resignation_tables_on_employee_id"
  end

  add_foreign_key "annual_summaries", "employees"
  add_foreign_key "annual_summary_remarks", "annual_summaries"
  add_foreign_key "annual_summary_remarks", "employees", column: "reviewer_id"
  add_foreign_key "empleaves", "employees"
  add_foreign_key "employee_addresses", "employees"
  add_foreign_key "employee_education_details", "employees"
  add_foreign_key "employee_financial_infos", "employees"
  add_foreign_key "employees", "employees", column: "associated_manager_id"
  add_foreign_key "employees", "projects"
  add_foreign_key "events", "employees"
  add_foreign_key "events", "employees", column: "individual_id"
  add_foreign_key "events", "projects"
  add_foreign_key "histories", "employees"
  add_foreign_key "leave_counters", "employees"
  add_foreign_key "projects", "employees", column: "project_lead_id"
  add_foreign_key "quarterly_appraisal_remarks", "employees", column: "reviewer_id"
  add_foreign_key "quarterly_appraisal_remarks", "quarterly_appraisals"
  add_foreign_key "quarterly_appraisals", "employees"
  add_foreign_key "resignation_tables", "employees"
end
